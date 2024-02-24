use Cro::HTTP::Router;
use Cro::WebApp::Template;
use Red:api<2>;
use Models::Post;
use Models::User;
use Routes::Post;
use Routes::User;
use Crypt::Argon2;
use Email::Valid;

sub resource-routes() {
    route {
        get -> 'css', *@path { resource 'css', @path; }
        get -> 'js',  *@path { resource 'js', @path; }
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

        get -> 'about' {
            template 'templates/about.crotmp';
        }

        include resource-routes();
    }
}
