use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Red:api<2>;
use Models::Post;
use Models::User;
use Crypt::Argon2;
use Email::Valid;

sub post-routes() is export {
    route {
        get -> {
            my @posts = Post.^all;
            template 'templates/posts/all-posts.crotmp', { :@posts };
        }

        # get -> EditorSession $session (User $user), 'new' {
        #     template 'templates/new-post.crotmp';
        # }

        # get -> 'new' {
        #     template 'template/unauthorized.crotmp';
        # }

        get -> 'new' {
            template 'templates/posts/new-post.crotmp';
        }

        get -> Int $id {
            my $post = Post.^load(:$id);

            template 'templates/posts/single-post.crotmp', { :$post }
        }

        post -> {
            request-body -> (:$title, :$body, *%) {
                my Post $post = Post.^create(:$title, :$body);

                my $new-post-location = "/posts/{$post.id}";
                header 'HX-Location', $new-post-location;
                created $new-post-location, 'text/html', '<h1>Post created</h1>';
            }
        }
    }
}