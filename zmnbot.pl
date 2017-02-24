#!/usr/bin/perl
    use warnings;
	use Data::Dumper;
	use Chatbot::Eliza;


	package zmnBot;
    use base qw( Bot::BasicBot );
	our $last_time=0;
	our $last_time_short=0;
	our $asker_spoke_last_time=0;
	our $asker_handle='';
	our $bot_name = "zmNinjaBot";
	$eliza = new Chatbot::Eliza;

    sub said {
      my ($self, $message) = @_;

	  my $who = $message->{who};
	  # lets record the last time asker spoke
	  if (($who eq "asker") || ($who eq "asker_") || ($who eq "_asker"))
	  {
		$asker_spoke_last_time=time();
	  }

	  my @nicks =  $self->pocoirc->nicks();
	  my $asker_here = 0;
	  foreach (@nicks) {if (($_ eq "asker") || ($_ eq "_asker") || ($_ eq "asker_")) {$asker_here=1; $asker_handle=$_; last; } } 
	  if ((defined($message->{address}) && $message->{address} =~ /\Q$bot_name/) || ($message->{body} =~ /\Q$bot_name/) )
	  {
		return $eliza->transform($message->{body});
		#return "I hear you";
	  }

	  # if asker is here, wait a while before responding

      if ($message->{body} =~ /\bzmninja\b/i) {
		if (!$asker_here)
		{
				if (time() - $last_time > 600)
				{
					$last_time = time();
					$last_time_short = time();
				  return "If you are facing issues with zmNinja, you have a few options: a) Wait for 'asker' to join IRC (US East coast time) b) create an issue at https://github.com/pliablepixels/zmNinja/issues or c) Send an email to pliablepixels\@gmail.com in that order. Thanks.";
				}
				elsif (time() - $last_time_short > 60)
				{
					$last_time_short = time();
					return "Hi, if you are facing issues with zmNinja, you need to wait for asker to join (see my previous posts)";
				}
				else
				{
					return;
				}
		} # asker not here
		else #asker is here
		{
			if (time() - $asker_spoke_last_time > 120)
			{
				$asker_spoke_last_time=time();
				return "hey $asker_handle - wake up, please. Someone asked about zmN"
			}
		}
      }
    }


    # Create an instance of the bot and start it running. Connect
    # to the main perl IRC server, and join some channels.
   my $bot = zmnBot->new(
      server => 'irc.freenode.net',
      channels => [ '#zoneminder' ],
      #channels => [ '#bottest' ],
      nick => 'zmNinjaBot',
	  no_run => 1,
    );
	$bot->{botid} = $bot;
	$bot->run();
	use POE;
	$poe_kernel->run();
