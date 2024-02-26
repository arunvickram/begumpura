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
    my @posts = [
        %( 
            :image('https://images.unsplash.com/photo-1708757857748-96f483962334?q=80&w=3851&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            :title('The Apparatchik'),
            :deck("Mohan Yadav's rise from obscurity"),
            :link('#'),
        ),
        %( 
            :image('https://images.unsplash.com/photo-1644682980822-e846ae175603?q=80&w=3774&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"'),
            :title('On the Defensive'),
            :deck("How the military fell in line with Modi’s political project "),
            :link('#'),
        ),
        %( 
            :image('https://images.unsplash.com/photo-1708757857748-96f483962334?q=80&w=3851&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            :title('The Apparatchik'),
            :deck("Mohan Yadav's rise from obscurity"),
            :link('#'),
        ),
        %( 
            :image('https://images.unsplash.com/photo-1644682980822-e846ae175603?q=80&w=3774&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"'),
            :title('On the Defensive'),
            :deck("How the military fell in line with Modi’s political project "),
            :link('#'),
        ),
        %( 
            :image('https://images.unsplash.com/photo-1708757857748-96f483962334?q=80&w=3851&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            :title('The Apparatchik'),
            :deck("Mohan Yadav's rise from obscurity"),
            :link('#'),
        ),
    ];

    route {
        # before Cro::HTTP::Session::Red[UserSession].new: cookie-name => "MY_SESSION_COOKIE_NAME";

        resources-from %?RESOURCES;
        templates-from-resources;

        include posts => post-routes(),
                users => user-routes();

        get -> {
            template 'templates/index.crotmp', { :@posts };
        }

        get -> 'about' {
            template 'templates/about.crotmp';
        }

        include resource-routes();
    }
}
