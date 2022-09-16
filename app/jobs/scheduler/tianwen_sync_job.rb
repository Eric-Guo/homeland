# frozen_string_literal: true

module Scheduler
  class TianwenSyncJob < ApplicationJob
    def perform
      prefix = 'topics'
      system("rm -rf #{Tianwen.store_path.join("#{prefix}_*.xml")}")
      Topic.find_each do |topic|
        topic.write_tianwen_xml(prefix)
      end
    end
  end
end
