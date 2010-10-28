# Install hook code here
%w(charts).each do |dir|
  source = File.expand_path(File.join(File.dirname(__FILE__), 'public', dir))
  target = File.join(Rails.root, 'public')
  FileUtils.mkdir_p target
  FileUtils.cp_r(source, target, :verbose => true)
end