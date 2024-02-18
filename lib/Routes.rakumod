use Cro::HTTP::Router;

sub routes() is export {
    route {
        get -> {
            content 'text/html', "<h1> begumpura </h1>";
        }


        # Blog post routes
    }
}
