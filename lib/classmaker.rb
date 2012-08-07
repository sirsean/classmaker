require 'fileutils'
require 'erb'

class Variable
    attr_reader :name, :type, :getter_and_setter

    def initialize(name, type, getter_and_setter=false)
        @name = name
        @type = type
        @getter_and_setter = getter_and_setter
    end

    def self.parse(arg)
        m = arg.match(/([^:]+):([^:]+):?([^:]+)?/)
        name = m[1]
        type = m[2]
        getter_and_setter = (!m[3].nil? and m[3].downcase == "y")
        Variable.new(name, type, getter_and_setter)
    end

end

# need to reopen the String class to add a method to it
class String
    # capitalize the first letter in a string, and leave the rest of the string alone
    def capitalize_first
        self[0..0].capitalize + self[1..-1]
    end

    # turn "FieldOneAndTwo" into "field_one_and_two"
    def camel_case_to_underscores
        if self.nil? or self.length < 2
            return self
        end
        copy = self.downcase
        indexes = []
        (1..(self.length-1)).each{ |index|
            c = self[index,1]
            if c != c.downcase
                indexes << index
            end
        }
        indexes.each_index{ |i|
            copy.insert(indexes[i] + i, "_")
        }
        copy
    end
end

class BaseTemplate
    attr_reader :package, :class_name

    def initialize(config, template_filename, extension)
        @config = config
        @template_filename = template_filename
        @extension = extension

        @name = @config[:name]
        @year = Time.now.year.to_s
    end

    def read_contents
        File.read(@template_filename)
    end

    def full_class_name
        @package + "." + @class_name
    end

    def build
        setup_binding
        ERB.new(read_contents).result(binding)
    end

    def setup_binding
        # do nothing here, let the subclass set up its own special bindings
    end

    def directory_path
        @config[:src_base] + "/" + @package.gsub(".", "/")
    end

    def file_name
        if not @class_name or not @extension
            raise "Invalid filename. Must have both a class name and an extension."
        end
        @class_name + "." + @extension
    end

    def file_exist?
        File.exist?(directory_path + "/" + file_name)
    end

    def write
        if not File.exist?(directory_path)
            FileUtils.makedirs(directory_path)
        end
        file = File.new(directory_path + "/" + file_name, "w+")
        file.write(build)
        file.close
    end
end

class JavaClassTemplate < BaseTemplate
    def initialize(config, package, class_name, fields)
        super(config, "#{ENV["HOME"]}/.classmaker/class_template.java.erb", "java")
        @package, @class_name, @fields = package, class_name, fields
    end

    def setup_binding
        @imports = @fields.select{ |field|
            ["Date"].include?(field.type) or field.type =~ /^List.*/ or field.type =~ /^Map.*/ or field.type =~ /^Set.*/
        }.map{ |field|
            if field.type =~ /^List.*/
                type = "List"
            elsif field.type =~ /^Map.*/
                type = "Map"
            elsif field.type =~ /^Set.*/
                type = "Set"
            else
                type = field.type
            end
            case type
            when "Date"; "java.util.Date"
            when "List"; "java.util.List"
            when "Map"; "java.util.Map"
            when "Set"; "java.util.Set"
            end
        }.uniq
    end

end

class JavaInterfaceTemplate < BaseTemplate
    def initialize(config, package, class_name)
        super(config, "#{ENV["HOME"]}/.classmaker/interface_template.java.erb", "java")
        @package, @class_name = package, class_name
    end

    def setup_binding
    end
end

class JavaTestTemplate < BaseTemplate
    def initialize(config, package, class_name)
        super(config, "#{ENV["HOME"]}/.classmaker/test_template.java.erb", "java")
        @package, @class_name = package, class_name
    end

    def setup_binding
    end
end

