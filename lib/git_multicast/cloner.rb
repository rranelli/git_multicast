require 'net/http'
require 'json'

module GitMulticast
  class Cloner
    include Process

    def initialize(username, dir)
      @username = username
      @dir = dir
    end

    def clone!
      start_time = Time.now
      repos = RepositoryFetcher.get_all_repos_from_user(username)
      output_status_zip = clone_em_all!(repos)

      OutputFormatter.format(output_status_zip, start_time)
    end

    protected

    attr_reader :username, :dir

    def clone_em_all!(repos)
      streams = spawn_processes(repos)

      _, statuses = waitall.transpose

      output = read_output(streams)
      output.zip(statuses)
    end

    def spawn_processes(repos)
      repos.map do |repo|
        r, w = IO.pipe
        w.write("Clonning: #{repo.name}\n")
        spawn(make_command(repo), out: w, err: w)
        [r, w]
      end
    end

    def read_output(streams)
      streams.map do |r, w|
        w.close unless w.closed?
        r.read
      end
    end

    def make_command(repo)
      if repo.fork
        parent_repo = RepositoryFetcher.get_repo_parent(repo.url)
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)} && \
git -C \"#{File.join(dir, repo.name)}\" remote add upstream \
#{parent_repo.ssh_url} --fetch"
      else
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)}"
      end
    end
  end
end
