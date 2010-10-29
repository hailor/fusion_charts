require 'builder'
module Ironmine
  class Chart

    attr_reader :content
    def initialize( options={} )
      @content = {}
      @content.merge!({:options=>options})
    end

    def push(key,data)
      if @content.key?(key)
        @content[key][:details]<<(data)
      else
        @content.merge!({key=>{:options=>{},:details=>[data]}})
      end
    end

    def set_options(key,options={})
      if @content.key?(key)
        @content[key][:options].merge!(options)
      else
        @content.merge!({key=>{:options=>options,:details=>[]}})
      end
    end


    def add_data(data,options={})
      datas = {:options=>options,:details=>[]}
      raise ArgumentError, "data must be array" if !data.is_a?(Array)
      data.each do |d|
        if d.is_a?(Hash)
          datas[:details]<<d
        else
          datas[:details]<<{:value=>d}
        end
      end
      @content[:datasets]||=[]
      @content[:datasets]<<datas
    end

    def add_category(categories,options={})
      set_options(:categories,options)
      raise ArgumentError, "category must be array" if !categories.is_a?(Array)
      categories.each do |c|
        if c.is_a?(Hash)
          push(:categories,c)
        else
          push(:categories,{:name=>c})
        end
      end
    end

    def to_s
      return single_data if(@content[:datasets].size==1)
      @xml = Builder::XmlMarkup.new
      @xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      @xml.graph(to_xml_options(@content[:options]||{})) do
          @xml.categories(to_xml_options(@content[:categories][:options])) do
            (@content[:categories][:details]||[]).each do |c_data|
              @xml.category(to_xml_options(c_data))
            end
          end
          (@content[:datasets]||[]).each do |d_data|
            @xml.dataset(to_xml_options(d_data[:options])) do
              d_data[:details].each do |d_s_data|
                @xml.set(to_xml_options(d_s_data))
              end if d_data[:details]
            end
          end
        end
        @xml.target!
    end

    def single_data
      @xml = Builder::XmlMarkup.new
      @xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      @xml.graph(to_xml_options(@content[:options]||{})) do
        (@content[:categories][:details]||[]).each_index do |index|
          ops = @content[:categories][:details][index].merge(@content[:datasets][0][:details][index])
          @xml.set(to_xml_options(ops))
        end
      end
      @xml.target!
    end

    private
    def to_xml_options(hash={})
      camelize_hash = {}
      hash.each do |key,value|
        if key.is_a?(Symbol)
          camelize_hash.merge!({key.to_s.camelize(:lower).to_sym=>value})
        else
          camelize_hash.merge!(key=>value)
        end
      end
      camelize_hash
    end
  end
end