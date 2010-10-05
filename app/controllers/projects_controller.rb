class ProjectsController < ApplicationController

  before_filter :login_required

  def index
    json 'projects' => Project.accessible(current_account)
  end

  def create
    json :model => current_account.projects.create(pick(:model, :title, :document_ids))
  end

  # TODO: Ensure that the document ids you're adding are for documents you
  # have access to.
  def update
    data = pick(:model, :title, :document_ids)
    current_project.update_attributes(:title => data[:title]) if data[:title]
    current_project.set_documents(data[:document_ids])
    json :model => current_project.reload
  end

  def destroy
    current_project(true).destroy
    json nil
  end

  def documents
    json 'documents' => current_project.loaded_documents
  end


  private

  def current_project(only_owner=false)
    return @current_project if @current_project
    base = only_owner ? current_account.projects : Project.accessible(current_account)
    @current_project = base.find(params[:id])
  end

end