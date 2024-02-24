use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Red:api<2>;
use Models::Post;
use Models::User;
use Crypt::Argon2;
use Email::Valid;

sub user-routes() is export {
    route {
        get -> 'register' {
            template 'templates/users/signup.crotmp';
        }

        get -> 'login' {
            template 'templates/users/login.crotmp';
        }

        post -> 'register', 'validate' {
            request-body -> (Str() :$email, Str() :$password, *%) {
                # my $email-validator = Email::Valid.new(:simple);

                # my %validation = email => %(), password => %();

                # ## validate email
                # %validation<email> ||= do unless $email-validator.validate($email) {
                #     %{ message => 'Invalid email format', invalid => 'true' }
                # };

                # my $user = User.^load(:$email);
                # %validation<email> ||= do if ?$user {
                #     %{ message => 'Email already taken', invalid => 'true' }
                # };
                
                # %validation<email> ||= %{ message => 'Looks good!', invalid => 'false' };

                # ## validate password
                # template 'templates/validation-input.crotmp', { :$email, :%validation };
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

        post -> UserSession $session, 'login' {
            request-body -> (Str() :$email, Str() :$password, *%) {
                given User.^load(:$email) {
                    if .?is-correct-password($password) {
                        $session.user = $_;
                        $session.^save;
                        
                        header 'HX-Location', '/';
                    } else {
                        template 'templates/users/login.crotmp', { :invalid(True) }
                    }
                }
            }
        }
    }
}
