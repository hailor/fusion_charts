# Include hook code here
require File.dirname(__FILE__) + '/lib/chart'
require File.dirname(__FILE__) + '/lib/fusion_charts'
ActionView::Base.send(:include,Ironmine::FusionChartHelper)

