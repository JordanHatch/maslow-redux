class Settings::PropositionStatementsController < Settings::BaseController

  def create
    create_or_update(:create, :new)
  end

  def update
    create_or_update(:update, :edit)
  end

  def destroy
    proposition_statement.destroy
    flash.notice = I18n.t("flash_messages.settings.proposition_statements.destroy")
    redirect_to settings_proposition_statements_path
  end

private
  helper_method :proposition_statements, :proposition_statement

  def proposition_statements
    @proposition_statements ||= PropositionStatement.all
  end

  def proposition_statement
    @proposition_statement ||=
      params.key?(:id) ?
        proposition_statements.find(params[:id]) :
        proposition_statements.build
  end

  def statement_params
    params.require(:proposition_statement).permit(:name, :description)
  end

  def create_or_update(key, action)
    proposition_statement.assign_attributes(statement_params)

    if proposition_statement.save
      flash.notice = I18n.t("flash_messages.settings.proposition_statements.#{key}")
      redirect_to settings_proposition_statements_path
    else
      render action: action
    end
  end

end
