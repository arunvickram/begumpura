use v6.d;
use Red:api<2>;
use Crypt::Argon2;
use Cro::HTTP::Auth;
use Cro::HTTP::Session::Red;

model User is table<users> is export {
  also is rw;

  has Int  $.id              is serial;
  has Str  $.email           is column{ :unique, :type<text> };
  has Str  $.hashed-password is column{ :type<text> };
  has Bool $.is-editor       is column = False;
  has      @.posts           is relationship( *.author-id, :model<Post>, :require<Models::Post> );

  # method active-posts { @!posts.grep: not *.deleted }
  method is-correct-password(Str $password --> Bool) { argon2-verify($.hashed-password, $password) }
}

model UserSession is table<user_session> is export does Cro::HTTP::Auth {
  has Str  $.id         is id;
  has UInt $.uid        is referencing( *.id, :model(User) );
  has User $.user       is relationship{ .uid } is rw;
}

subset LoggedInSession is export is sub-model of UserSession     where .user.defined;
subset EditorSession   is export is sub-model of LoggedInSession where .user.is-editor;