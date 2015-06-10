class Proweb::FileCleaner

  def initialize
    @project_id = Proweb.config["project_id"]
    @source_dir = Proweb.config["files"]["source"]
    @intermediate_dir = File.expand_path(Proweb.config["files"]["intermediate"])
    @dest_dir = File.expand_path(Proweb.config["files"]["target"])
  end

  def run
    sync
    build_link_tree
    match_objects
  end

  def sync
    system "mkdir -p #{@intermediate_dir}"
    system "rsync -av #{@source_dir} #{@intermediate_dir}"
  end

  def build_link_tree
    puts @intermediate_dir
    puts @dest_dir

    system "rm -rf #{@dest_dir}"
    system "mkdir -p #{@dest_dir}"

    Dir["#{@intermediate_dir}/*/*"].each do |dir|
      if File.directory?(dir) && (m = dir.match(/_(\d+)_$/))
        id = m.to_a.last
        system "ln -sfn #{dir} #{@dest_dir}/#{id}"
      end
    end
  end

  def match_objects
    Proweb::Project.find(@project_id).objects.each do |object|
      dir = "#{@dest_dir}/#{object.id}"
      if File.directory?(dir)
        files = Dir["#{dir}/*"].reject{|f| f.match "Zeige Objekt "}
        if files.empty?
          puts "ID: #{object.id}:"
          puts "  NO FILES"
        else
          # puts "ID: #{object.id}:"
          # files.each do |file|
          #   puts "  #{file}"
          # end
        end
      else
        puts "ID: #{object.id}:"
        puts "  NO DIR"
      end
    end
  end

end