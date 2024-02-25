use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Red:api<2>;
use Models::Post;
use Models::User;
use Crypt::Argon2;
use Email::Valid;
use Utils; 

sub user-routes() is export {
    route {
        get -> 'register' {
            template 'templates/users/signup.crotmp', { form-data => %() };
        }

        get -> 'login' {
            template 'templates/users/login.crotmp';
        }

        post -> 'register', 'validate' {
            request-body -> %data (Str() :$email, Str() :$password, Str() :$confirm-password, *%) {
                %( :%data )
                    ==> validate(
                            { Email::Valid.new(:simple).validate($^email) }, 
                            :key<email>, 
                            :error-message('Invalid email format')
                        )
                    ==> validate(
                            { !User.^load(:email($^email)) }, 
                            :key<email>, 
                            :error-message('Email already taken'),
                            :success-message('Email looks good!')
                        )
                    ==> my %form-data;
                
                if $password ne '' {
                     %form-data = validate(
                        { $^password.chars >= 8 },
                        %form-data,
                        :key<password>,
                        :error-message('Password must be longer than 8 characters'),
                        :success-message('Password is good to go!')
                    );
                }

                if $password ne '' && $confirm-password ne '' {
                    %form-data = validate(
                        { $^confirm-password eq $password },
                        %form-data,
                        :key<confirm-password>,
                        :error-message('Password does not match confirmation password'),
                        :success-message('Passwords match!')
                    );
                }

                template 'templates/users/signup_form_response.crotmp', { :%form-data };
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
