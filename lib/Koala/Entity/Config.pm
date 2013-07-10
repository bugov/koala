# Class: Koala::Entity::Config
#   Config singleton
package Koala::Entity::Config;
use Pony::Object qw/:try -singleton/;
use FindBin;
use JSON::XS;
  
  protected config => {};
  
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
