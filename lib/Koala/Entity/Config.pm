# Class: Koala::Entity::Config
#   Config singleton
package Koala::Entity::Config;
use Pony::Object qw/:try -singleton/;
use Pony::Object::Throwable;
use FindBin;
use JSON::XS;
  
  protected config => {};
  protected required => ['database'];
  
  # Method: init
  #   Constructor. Get all configs.
  sub init : Public
    {
      my $this = shift;
      local $/;
      
      for my $file (<$FindBin::Bin/../conf/*.json>) {
        my $conf = try {
          open(my $fh, $file) or die "Can't find $file";
          my $config = <$fh>;
          close $fh;
          return decode_json $config;
        } catch {
          return {};
        };
        $this->config = { %{$this->config}, %$conf };
      }
      
      my $message = '';
      $message .= qq{Can't find config "$_" but it's really necessary.\n}
        for grep {not exists $this->config->{$_}} @{$this->required};
      say($message, "See ./conf directory for more information"), exit if $message;
    }
  
  # Method: get_config
  #   Getter for config.
  #
  # Returns:
  #   HashRef
  sub get_config : Public
    {
      my $this = shift;
      return $this->config;
    }
  
1;
