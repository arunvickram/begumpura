use v6.d;
use Red:api<2>;
use Models::User;

unit module Models::Post;

model PostTag {...}

model Post is table<posts> is rw is export {
  has Int      $.id        is serial;
  has          $!author-id is referencing( *.id, :model<User> );
  has Str      $.body      is column;
  has          $.author    is relationship( *.author-id, :model<User> );
  has PostTag  @.post-tags is relationship{ .post-id };
  has Bool     $.deleted   is column = False;
  has DateTime $.created   is column .= now;

  method tags { @.post-tags>>.tag }
}

model Tag is table<tags> is export {
  has Str $.name is id;
  has PostTag @.post-tags is relationship{ .tag-id };

  method posts { @.post-tags>>.post }
}

model PostTag is table<post_tag> is export {
  has UInt $.post-id is column{ :id, :references{ .id }, :model-name<Post> }
  has Str  $.tag-id  is column{ :id, :references{ .id }, :model-name<Tag> }
  has Post $.post    is relationship{ .post-id };
  has Tag  $.tag     is relationship{ .tag-id };
}
