class ExportFileController < ApplicationController
  def action_allowed?
    ['Instructor',
     'Teaching Assistant',
     'Administrator',
     'Super-Administrator'].include? current_role_name
  end

  def start
    @model = params[:model]
    if @model == 'Assignment'
      @title = 'Grades'
    elsif @model == 'CourseParticipant'
      @title = 'Course Participants'
    elsif @model == 'AssignmentTeam'
      @title = 'Teams'
    elsif @model == 'CourseTeam'
      @title = 'Teams'
    elsif @model == 'User'
      @title = 'Users'
    end
    @id = params[:id]
  end

  def exportdetails
     @delim_type = params[:delim_type2]
     if @delim_type == "comma"
       filename = params[:model] + params[:id] + "_Details.csv"
       delimiter = ","
     elsif @delim_type == "space"
       filename = params[:model] + params[:id] + "_Details.csv"
       delimiter = " "
     elsif @delim_type == "tab"
       filename = params[:model] + params[:id] + "_Details.csv"
       delimiter = "\t"
     elsif @delim_type == "other"
       filename = params[:model] + params[:id] + "_Details.csv"
       delimiter = other_char2
     end
     
     puts "TEST DETAILS ARRAY"
     puts params[:options]
     puts params[:details]

     csv_data = CSV.generate(col_sep: delimiter) do |csv|
         csv << Object.const_get(params[:model]).export_Headers(params[:id])
         csv << Object.const_get(params[:model]).export_details_fields(params[:details])
         Object.const_get(params[:model]).export_details(csv, params[:id], params[:details])
     end
    
     send_data csv_data,
               type: 'text/csv; charset=iso-8859-1; header=present',
         disposition: "attachment; filename=#{filename}"
 
   end
 
  def export
    @delim_type = params[:delim_type]
    if @delim_type == "comma"
      filename = params[:model] + params[:id] + ".csv"
      delimiter = ","
    elsif @delim_type == "space"
      filename = params[:model] + params[:id] + ".csv"
      delimiter = " "
    elsif @delim_type == "tab"
      filename = params[:model] + params[:id] + ".csv"
      delimiter = "\t"
    elsif @delim_type == "other"
      filename = params[:model] + params[:id] + ".csv"
      delimiter = other_char
    end
    allowed_models = ['Assignment',
                      'AssignmentParticipant',
                      'AssignmentTeam',
                      'CourseParticipant',
                      'CourseTeam',
                      'MetareviewResponseMap',
                      'ReviewResponseMap',
                      'User',
                      'Team'
                      ]
    csv_data = CSV.generate(col_sep: delimiter) do |csv|
      if allowed_models.include? params[:model]
        csv << Object.const_get(params[:model]).export_fields(params[:options])
        Object.const_get(params[:model]).export(csv, params[:id], params[:options])
      end
    end

    send_data csv_data,
              type: 'text/csv; charset=iso-8859-1; header=present',
              disposition: "attachment; filename=#{filename}"
  end
end
