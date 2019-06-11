require "tsort"

# Extension of the hash class

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class Jobs
  SelfDependencyError = Class.new(StandardError)
  CircularDependencyError = Class.new(StandardError)

  def sort(input)
    job_list = split_input(input)

    job_list.tsort
  rescue TSort::Cyclic
    raise(CircularDependencyError, "Jobs can’t have circular dependencies")
  end

  private

  def split_input(input)
    map = {}
    lines = input.split("\n")

    # Splits the job and the dependency apart
    lines.each do |line|
      job, depen = line.split("=>").map(&:strip)

      raise(SelfDependencyError, "Jobs can't depend on themselves") if job == depen

      # Removes nil & removes empty strings from the dependency array
      if depen.nil? || depen.empty?
        map[job] = []
      else
        map[job] = [depen]
      end
    end

    map
  end
end
