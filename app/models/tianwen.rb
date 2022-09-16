# frozen_string_literal: true

class Tianwen
  def self.store_path
    raise Exception('未设置天问存储文件夹') unless ENV["TIANWEN_STORE_PATH"].present?
    Pathname.new(ENV["TIANWEN_STORE_PATH"])
  end

  def self.template_path
    Rails.root.join('public', 'tianwen_tile', 'default.xml')
  end

  def self.xml_to_dir(content, file_name)
    File.open(self.store_path.join("#{file_name}.xml"), 'wb') do |f|
      f.chmod(0666)
      f.write(content)
    end
  end

  def self.write_xml(file_name)
    tmpl = File.open(self.template_path) { |f| Nokogiri::XML(f) }
    yield tmpl
    self.xml_to_dir(tmpl.to_xml, file_name)
  end
end
