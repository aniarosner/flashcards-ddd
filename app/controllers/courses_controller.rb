class CoursesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: Courses::ReadModel.new.all, status: :ok }
      format.html { render action: :index, locals: { courses: Courses::ReadModel.new.all } }
    end
  end

  def create
    respond_to do |format|
      command_bus.call(Content::CreateCourse.new(course_uuid: params[:course_uuid]))
      command_bus.call(Content::SetCourseTitle.new(course_uuid: params[:course_uuid], title: params[:title]))

      format.json { head :no_content }
      format.html { redirect_to courses_path }
    end
  end

  def new
    course_uuid = SecureRandom.uuid

    respond_to do |format|
      format.html { render action: :new, locals: { course_uuid: course_uuid } }
    end
  end

  def destroy
    respond_to do |format|
      command_bus.call(Content::RemoveCourse.new(course_uuid: params[:uuid]))

      format.json { head :no_content }
      format.html { redirect_to courses_path }
    end
  end
end
