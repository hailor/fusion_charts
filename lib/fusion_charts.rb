# FusionCharts
module Ironmine
  module FusionChartHelper
    # Renders a chart from the swf file passed as parameter either making use of setDataURL method or
    # setDataXML method. The width and height of chart are passed as parameters to this function. If the chart is not rendered,
    # the errors can be detected by setting debugging mode to true while calling this function.
    # - parameter chart_swf :  SWF file that renders the chart.
    # - parameter str_xml : XML content.
    # - parameter chart_id :  String for identifying chart.
    # - parameter chart_width : Integer for the width of the chart.
    # - parameter chart_height : Integer for the height of the chart.
    # - parameter debug_mode :  (Not used in Free version)True ( a boolean ) for debugging errors, if any, while rendering the chart.
    # Can be called from html block in the view where the chart needs to be embedded.
    def render_chart_html(chart_type,str_xml,chart_id,chart_width,chart_height,debug_mode)
      chart_width=chart_width.to_s
      chart_height=chart_height.to_s
      chart_swf = "/charts/FCF_#{chart_type}.swf"
      debug_mode_num="0"
      if debug_mode==true
        debug_mode_num="1"
      end
      str_xml = str_xml.gsub(/"/, "'").gsub(/''/, "'")
      str_flash_vars="chartWidth="+chart_width+"&chartHeight="+chart_height+"&debugmode="+debug_mode_num+"&dataXML="+str_xml
      content = ""

      content << "\t\t<!-- START Code Block for Chart "+chart_id+" -->\n\t\t"

      object_attributes={:classid=>"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"}
      object_attributes=object_attributes.merge(:codebase=>"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0")
      object_attributes=object_attributes.merge(:width=>chart_width)
      object_attributes=object_attributes.merge(:height=>chart_height)
      object_attributes=object_attributes.merge(:id=>chart_id)

      param_attributes1={:name=>"allowscriptaccess",:value=>"always"}
      param_tag1=content_tag("param","",param_attributes1)

      param_attributes2={:name=>"movie",:value=>chart_swf}
      param_tag2=content_tag("param","",param_attributes2)

      param_attributes3={:name=>"FlashVars",:value=>str_flash_vars}
      param_tag3=content_tag("param","",param_attributes3)

      param_attributes4={:name=>"quality",:value=>"high"}
      param_tag4=content_tag("param","",param_attributes4)

      embed_attributes={:src=>chart_swf}
      embed_attributes=embed_attributes.merge(:FlashVars=>str_flash_vars)
      embed_attributes=embed_attributes.merge(:quality=>"high")
      embed_attributes=embed_attributes.merge(:width=>chart_width)
      embed_attributes=embed_attributes.merge(:height=>chart_height).merge(:name=>chart_id)
      embed_attributes=embed_attributes.merge(:allowScriptAccess=>"always")
      embed_attributes=embed_attributes.merge(:type=>"application/x-shockwave-flash")
      embed_attributes=embed_attributes.merge(:pluginspage=>"http://www.macromedia.com/go/getflashplayer")

      embed_tag=content_tag("embed","",embed_attributes,false)

      content << content_tag("object","\n\t\t\t\t"+param_tag1+"\n\t\t\t\t"+param_tag2+"\n\t\t\t\t"+param_tag3+"\n\t\t\t\t"+param_tag4+"\n\t\t\t\t"+embed_tag+"\n\t\t",object_attributes,false)
      content <<"\n\t\t<!-- END Code Block for Chart "+chart_id+" -->\n"
      content.html_safe
    end

  end
end
