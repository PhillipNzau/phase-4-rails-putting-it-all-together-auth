class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update, :destroy]

  # GET /recipes
  def index
    if current_user
      recipes = Recipe.all.includes(:user)
      render json: recipes, include: { user: { only: [:id, :username, :image_url, :bio] } }, status: :ok
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  # GET /recipes/1
  def show
    render json: @recipe
  end

  # POST /recipes
  def create
    if current_user
      recipe = current_user.recipes.build(recipe_params)
      if recipe.save
        render json: recipe, include: { user: { only: [:id, :username, :image_url, :bio] } }, status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      render json: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:references, :title, :instructions, :minutes_to_complete)
    end
end
