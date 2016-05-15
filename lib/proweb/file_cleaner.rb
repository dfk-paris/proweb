class Proweb::FileCleaner

  def initialize
    @project_ids = Proweb.config["project_ids"]
    @source_dirs = Proweb.config["files"]["sources"]
    @intermediate_dir = Pathname.new(Proweb.config["files"]["intermediate"]).realpath
    @dest_dir = Pathname.new(Proweb.config["files"]["target"]).realpath
  end

  def run
    sync
    build_link_tree
    verify_files_with_objects
  end

  def sync
    @source_dirs.each do |source_dir|
      puts "synchronizing #{source_dir}"
      ext = source_dir.split('/').last
      system "mkdir -p #{@intermediate_dir}/#{ext}"
      system "rsync -av --delete #{source_dir}/ #{@intermediate_dir}/#{ext}/"
    end
  end

  def build_link_tree
    puts "building link tree"

    system "rm -rf #{@dest_dir}"
    system "mkdir -p #{@dest_dir}"

    Dir["#{@intermediate_dir}/*/*/*"].each do |dir|
      if File.directory?(dir) && (m = dir.match(/_(\d+)_$/))
        id = m.to_a.last
        system "ln -sfn #{dir} #{@dest_dir}/#{id}"
      end
    end
  end

  def verify_files_with_objects
    @project_ids.each do |project_id|
      Proweb::Project.find(project_id).objects.each do |object|
        dir = "#{@dest_dir}/#{object.id}"
        if File.directory?(dir)
          files = Dir["#{dir}/*"].reject{|f| f.match "Zeige Objekt "}
          if files.empty?
            puts "ID: #{object.id}: NO FILES FOUND"
          end
        else
          puts "ID: #{object.id}: NO FILES FOUND (no directory found)"
        end
      end
    end
  end

end