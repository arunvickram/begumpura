use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Models::Post;

sub post-routes() {
    route {
        get -> {
            my @posts = Post.^all;
            template 'all-posts.crotmp', { :@posts };
        }

        get -> 'new' {
            template 'new-post.crotmp';
        }

        get -> Int $id {
            my $post = Post.^load(:$id);

            template 'single-post.crotmp', { :$post }
        }

        post -> {
            request-body -> (:$title, :$body) {
                my Post $post = Post.^create(:$title, :$body);

                my $new-post-location = "/posts/{$post.id}";
                header 'HX-Location', $new-post-location;
                created $new-post-location, 'text/html', '<h1>Post created</h1>';
            }
        }
    }
}

sub routes() is export {
    route {
        template-location 'resources/templates';

        include posts => post-routes();

        get -> {
            template 'index.crotmp';
        }
    }
}
