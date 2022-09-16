# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all'
  task all: %i[topics]

  desc 'Sync topics'
  task topics: :environment do
    prefix = 'topics'
    sh "rm -rf #{Tianwen.store_path.join("#{prefix}_*.xml")}"
    Topic.find_each do |topic|
      topic.write_tianwen_xml(prefix)
    end
  end
end
