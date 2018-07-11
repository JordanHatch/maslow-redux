require 'csv'
require 'rest_client'

class NeedImporter

  def initialize(csv_url:, logger: default_logger, max_responses: 3, max_met_when_criteria: 5)
    @csv_url = csv_url
    @logger = logger

    @max_responses = max_responses
    @max_met_when_criteria = max_met_when_criteria
  end

  def run!
    ensure_import_user_exists!

    CSV.parse(csv_body, csv_options) do |row|
      create_need_for_row(row)
    end

    logger.info "Import complete."
  end

private
  attr_reader :csv_url, :logger, :max_responses, :max_met_when_criteria, :user

  def ensure_import_user_exists!
    @user ||= User.find_or_initialize_by(email: 'need.importer@bots.maslow')
    @user.assign_attributes(
      name: 'Maslow needs importer bot',
      roles: ['bot']
    )
    @user.save!(validate: false)
  end

  def csv_body
    logger.info "GET #{csv_url}"
    @csv_body ||= RestClient.get(csv_url).body
  end

  def csv_options
    {
      headers: true
    }
  end

  def default_logger
    Logger.new(STDOUT)
  end

  def create_need_for_row(row)
    need = Need.new(attributes_for_need(row))

    logger.info "NEED: As a #{need.role}, I need to #{need.goal}, so that #{need.benefit}"

    if need.save_as(user)
      logger.info "\tCREATED".colorize(:green)

      create_decisions_for_need(need, row)
      create_responses_for_need(need, row)
      create_taggings_for_need(need, row)
    else
      logger.warn "\tFAILED: ".colorize(:red) + need.errors.full_messages.join("; ")
    end
  end

  def attributes_for_need(row)
    {
      role: row['Role'],
      goal: row['Goal'],
      benefit: row['Benefit'],
      met_when: met_when_for_need(row),
      legislation: row['Legislation'],
      other_evidence: row['Other evidence'],
      yearly_user_contacts: row['Yearly user contacts'],
      yearly_searches: row['Yearly searches'],
      yearly_need_views: row['Yearly need views'],
      yearly_site_views: row['Yearly site views'],
    }
  end

  def met_when_for_need(row)
    (1..max_met_when_criteria).map {|n|
      row["Met when #{n}"]
    }.compact
  end

  def create_decisions_for_need(need, row)
    decisions = {
      scope: row['In scope?'],
      completion: row['Complete?'],
      met: row['Met?'],
    }

    decisions.each do |type, outcome|
      decision = need.decisions.build(decision_type: type, outcome: outcome, user: user)

      logger.info "\tDECISION: #{type} => #{outcome}"

      if decision.save
        logger.info "\t\tCREATED".colorize(:green)
      else
        logger.warn "\t\tFAILED: ".colorize(:red) + decision.errors.full_messages.join("; ")
      end
    end
  end

  def create_responses_for_need(need, row)
    responses = (1..max_responses).map {|n|
      {
        response_type: row["Response #{n}: Type"],
        name: row["Response #{n}: Name"],
        url: row["Response #{n}: URL"],
      }
    }

    responses.each do |atts|
      response = need.need_responses.build(atts)

      logger.info "\tRESPONSE: #{response.response_type} – #{response.name}"

      if response.save_as(user)
        logger.info "\t\tCREATED".colorize(:green)
      else
        logger.warn "\t\tFAILED: ".colorize(:red) + response.errors.full_messages.join("; ")
      end
    end
  end

  def create_taggings_for_need(need, row)
    TagType.all.each do |type|
      tag_strings = row["Tags: #{type.name}"]&.split(';')

      next unless tag_strings.present?

      tags = tag_strings.map {|string|
        type.tags.where('LOWER(name) = ?', string.downcase.lstrip).first
      }.compact

      need.set_tags_of_type(type, tags)
      logger.info("\tTAG #{type.name}: #{tags.size}/#{tag_strings.size} tags added")
    end
  end

end
