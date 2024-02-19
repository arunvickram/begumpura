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

        post -> {
            request-body -> (:$title, :$body) {
                my Post $post = Post.^create(:$title, :$body);
                say "Post title: $title";
                say "Post body: $body";
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
