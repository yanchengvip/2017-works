class Manage::AuthorityRoleRelationshipsController < ApplicationController
  before_action :set_manage_authority_role_relationship, only: [:show, :edit, :update, :destroy]
  before_action :side_menus6

  def index
    @manage_authority_role_relationships = Manage::AuthorityRoleRelationship.all
  end


  def show
  end


  def new
    @manage_authority_role_relationship = Manage::AuthorityRoleRelationship.new
  end


  def edit
  end


  def create
    @manage_authority_role_relationship = Manage::AuthorityRoleRelationship.new(manage_authority_role_relationship_params)


  end


  def update

      if @manage_authority_role_relationship.update(manage_authority_role_relationship_params)

      else

      end

  end


  def destroy
    @manage_authority_role_relationship.destroy

  end

  private

    def set_manage_authority_role_relationship
      @manage_authority_role_relationship = Manage::AuthorityRoleRelationship.find(params[:id])
    end


    def manage_authority_role_relationship_params
      params.fetch(:manage_authority_role_relationship, {})
    end
end
