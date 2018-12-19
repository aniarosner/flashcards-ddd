class CoursesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: CourseListReadModel.new.all, status: :ok }
    end
  end

  def create
    respond_to do |format|
      format.json do
        command_bus.call(Content::CreateCourse.new(course_uuid: params[:course_uuid]))
        head :no_content
      end
    end
  end
end
