# Default evidence types

EvidenceType.create!(
  name: 'Legislation underpinning this need',
  description: 'Please provide a URL where possible',
  kind: :qualitative,
)
EvidenceType.create!(
  name: 'User contacts for this need per year',
  description: 'Include calls to contact centres, emails, customer service tickets, etc.',
  kind: :quantitative,
)
EvidenceType.create!(
  name: 'Pageviews specific to this need per year',
  description: 'Combine the pageviews for all relevant content.',
  kind: :quantitative,
)
