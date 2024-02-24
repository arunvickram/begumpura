use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Models::Post;
use Models::User;
use Crypt::Argon2;
use Email::Valid;

sub resource-routes() {
    route {
        get -> 'css', *@path { resource 'css', @path; }
        get -> 'js', *@path { resource 'js', @path; }
    }
}

subset LoggedInSession is sub-model of UserSession where .user.defined;

sub user-routes() {
    route {
        get -> 'register' {
            template 'templates/signup.crotmp';
        }

        get -> 'login' {
            template 'templates/login.crotmp';
        }

        post -> 'register', 'validate' {
            request-body -> (:$email, :$password) {
                my $email-validator = Email::Valid.new(:simple);

                my %validation = email => %{}, password => %{};

                ## validate email
                %validation<email> ||= do unless $email-validator.validate($email) {
                    %{ message => 'Invalid email format', invalid => 'true' }
                };

                my $user = User.^load(:$email);
                %validation<email> ||= do if ?$user {
                    %{ message => 'Email already taken', invalid => 'true' }
                };
                
                %validation<email> ||= %{ message => 'Looks good!', invalid => 'false' };


                ## validate password
                template 'templates/validation-input.crotmp', { :$email, :%validation };
            }
        }

        post -> 'register' {
            request-body -> (:$email, :$password) {
                my $hashed-password = argon2-hash $password;
                my $user = User.^create(:$email, :$hashed-password);

                header 'HX-Location', '/users/login';
                created '/users/login';
            }
        }

        post -> 'session' {
            request-body -> (:$email, :$password) {

            }
        }
    }
}

sub post-routes() {
    route {
        get -> {
            my @posts = Post.^all;
            template 'templates/all-posts.crotmp', { :@posts };
        }

        get -> 'new' {
            template 'templates/new-post.crotmp';
        }

        get -> Int $id {
            my $post = Post.^load(:$id);

            template 'templates/single-post.crotmp', { :$post }
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
        before Cro::HTTP::Session::Red[UserSession].new: cookie-name => "MY_SESSION_COOKIE_NAME";

        resources-from %?RESOURCES;
        templates-from-resources;

        include posts => post-routes(),
                users => user-routes();

        get -> {
            template 'templates/index.crotmp';
        }

        include resource-routes();
    }
}
