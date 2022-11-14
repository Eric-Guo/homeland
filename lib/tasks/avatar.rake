namespace :avatar do
  desc "Generate the unicornify"
  task generate: :environment do
    User.find_each do |user|
      GenerateUnicornifyAvatarJob.perform_inline(user.id)
    end
  end
end
