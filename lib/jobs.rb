require "tsort"

# extension of the hash class

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class Jobs

  def sort(input)
    job_list = split_input(input)
    job_list.tsort
  end

  private
  def split_input(input)
    map = {}
    lines = input.split("\n")
    #splits the job and the dependency apart
    lines.each do |line|
      job, depen = line.split("=>").map(&:strip)
    #removes nil & removes empty strings from the dependency array
    if depen.nil? || depen.empty?
      map[job] = []
    else
      map[job] = [depen]
    end

  end
    map
  end
end
