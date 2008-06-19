module WaterChemistrySamplingHelper
  def create_results_chart(rows, columns)
    data = rows.collect do |row|
      row.collect do |value|
        value || 0
      end
    end
    
    
    Gchart.line(
      :size => '700x400', 
      :data => data,
      :title => "Results", 
      :bar_colors => ['FF0000','00FF00'],
      :background => 'EEEEEE', 
      :chart_background => 'CCCCCC',
      :axis_with_labels => ['x'],
      :axis_labels => [columns]
    )
  end
end
