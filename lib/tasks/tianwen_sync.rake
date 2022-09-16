# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all'
  task all: %i[topics]

  desc 'Sync topics'
  task topics: :environment do
    Scheduler::TianwenSyncJob.perform_now
  end
end
