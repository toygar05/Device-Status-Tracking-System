class PostsController < ApplicationController
  def new
  end

def destroy
  @post = Post.find(params[:id])
  @post.destroy
 
  redirect_to posts_path
end

 def edit
  @post = Post.find(params[:id])
 end

 def update
  @post = Post.find(params[:id])
 
  if @post.update(params[:post].permit(:name, :brand, :model, :problem, :result))
    redirect_to @post
  else
    render 'edit'
  end

end
 def index
  @posts = Post.all
 end
 
 def show
  @post = Post.find(params[:id])
 end

 def create
  @post = Post.new(post_params)
 
  @post.save
  redirect_to welcome_index_path
 end
 
 private
  def post_params
    params.require(:post).permit(:name, :brand, :model, :problem, :result)
 end
end