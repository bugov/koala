package Koala::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;
use Koala::Model::Comment;
use Koala::Model::Category;
use Koala::Model::Tag;

my $size = 20;

sub list {
  my $self = shift;
  my $page = int $self->param('page') || 1;
  my $list = eval {
    Koala::Model::Page::Manager->get_pages(
      where => [status => {ge => 50}],
      sort_by => '-id',
      limit => $size,
      offset => $size * ($page-1)
    )
  } or return $self->not_found;
  my $count = Koala::Model::Page::Manager->get_pages_count(where => [status => {ge => 50}]);
  $self->render(list => $list, count => $count, limit => $size);
}

sub show {
  my $self = shift;
  my $url = $self->remove_last_slash($self->param('url'));
  my $page = eval{Koala::Model::Page->new(url => $url)->load} or return $self->list_by_category;
  my $comment_list = Koala::Model::Comment::Manager
    ->get_comments(where => [page_id => $page->id, status => {gt => 0}], sort_by => '-id', limit => $size);
  my $comment_count = Koala::Model::Comment::Manager
    ->get_comments_count(where => [page_id => $page->id], status => {gt => 0});
  $self->render(page => $page, comment_list => $comment_list, comment_count => $comment_count);
}

sub list_by_category {
  my $self = shift;
  my $url = $self->remove_last_slash($self->param('url'));
  my $category = eval { Koala::Model::Category->new(url => $url)->load } or return $self->list_by_tag;
  my $list = Koala::Model::Page::Manager->get_pages(where => [category_id => $category->id], sort_by => '-id');
  $self->render('page/list_by_category', category => $category, list => $list);
}

sub list_by_tag {
  my $self = shift;
  my $url = $self->remove_last_slash($self->param('url'));
  my $tag = eval { Koala::Model::Tag->new(url => $url)->load } or return $self->not_found;
  my $list = $tag->pages;
  $self->render('page/list_by_tag', tag => $tag, list => $list);
}

sub remove_last_slash {
  my $self = shift;
  my $url = shift;
  chop $url if $url =~ /\/$/;
  return $url;
}

1;
