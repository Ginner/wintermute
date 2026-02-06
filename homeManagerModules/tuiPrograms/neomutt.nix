{ config, pkgs, lib, ... }:

{
  options.myHomeModules.tuiPrograms.neomutt = {
    enable = lib.mkEnableOption "neomutt TUI mail app";
  };

  config = lib.mkIf config.myHomeModules.tuiPrograms.neomutt.enable {
    home.packages = with pkgs; [
      neomutt
      isync   # mbsync
      msmtp
      rbw     # Depend on whether bitwarden is enabled, otherwise default to pass
      gnupg
      notmuch
      lynx
      khard
      urlscan
      w3m
    ];
    programs.notmuch = {
      enable = true;
      new.tags = [ "unread" "inbox" ];
      new.ignore = [ ".mbsyncstate" ".uidvalidity" ];
      search.excludeTags = [ "deleted" "spam" ];
      maildir.synchronizeFlags = true;
      extraConfig = {
        database.path = "${config.xdg.dataHome}/mail";
      };
    };
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      sidebar = {
        enable = true;
        shortPath = true;
        width = 28;
        visible = true;
        format = "%D%* %?F? %F? %?N?%N/?%?S?%S?";
      };
      settings = {
        nobeep = true;
        allow_ansi = true;
        status_chars = " ";
        date_format = "%Y.%m.%d %H:%M";
        index_format = "%3C %Z %?X?& ? %D %-20.20F %s";
        sidebar_divider_char = " | ";   # Character used as divider between sidebar and panels
        sidebar_indent_string = "  ";   # Indent mailboxes this amount
        sidebar_next_new_wrap = "yes" ;    # Should search wrap around when it reaches the end of the list?
        sidebar_sort_method = "unsorted";    # ['unsorted'] Method for sorting the mailboxes
        markers = false;
      };
      binds = [
        { action = "noop"; key = "\\Ck"; map = [ "index" "pager" ]; }
        { action = "noop"; key = "\\Cj"; map = [ "index" "pager" ]; }
        { action = "noop"; key = "\\Co"; map = [ "index" "pager" ]; }
        { action = "recall-message"; key = "P"; map = [ "index" "pager" ]; }
        { action = "group-reply"; key = "R"; map = [ "index" "pager" ]; }
        { action = "bottom"; key = "G"; map = [ "pager" ]; }
        { action = "top"; key = "gg"; map = [ "pager" ]; }
        { action = "last-entry"; key = "G"; map = [ "attach" "browser" "index" ]; }
        { action = "first-entry"; key = "gg"; map = [ "attach" "browser" "index" ]; }
        { action = "complete-query"; key = "<tab>"; map = [ "editor" ]; }

      ];
      macros = [
        { action = "<sidebar-prev><sidebar-open>"; key = "\\Ck"; map = [ "index" "pager" ]; }
        { action = "<sidebar-next><sidebar-open>"; key = "\\Cj"; map = [ "index" "pager" ]; }
        { action = "<enter-command>set pipe_decode = yes<enter><pipe-message>urlscan<enter><enter-command>set pipe_decode = no<enter>"; key = "U"; map = [ "index" "pager" ]; } # View URLs
      ];

      extraConfig = ''
        #
        # Statusbar, date format, finding stuff etc.
        # set status_chars = " "               # Mailbox status symbols, called with '%r'. 'mailbox is unchanged', 'mailbox has changed and needs to be synced', 'mailbox is read-only', 'attach message mode'
        set to_chars = " "        # 'not adressed to your address', 'you are the only recipient', 'multiple recipient', 'you are cc', 'sent by you', 'mailing list', 'address in reply-to'
        set crypt_chars = " "       # Encryption status symbols, 'signed and verified', 'pgp encrypted', 'signed', 'contains public key', 'no crypto info'
        set flag_chars = " "  # 'tagged', 'important', 'flagged for deletion', 'attachment flagged for deletion', 'replied to', 'old - unread but seen', 'new mail', 'old thread', 'new tread', 'the mail is read'(%S), 'the mail is read' (%Z)
        set status_format = "%*-  %D%r  %m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)?  %?p?(  ---  %p postponed  )?%*-"

        # Allow showing longer attachment file-names (180)
        set attach_format = "%u%D%I %t%4n %T%.180d%> [%.7m/%.10M, %.6e%?C?, %C?, %s] "

        set use_threads=threads
        set sort=reverse-last-date
        set sort_aux=reverse-last-date   # this one is already the default
        set uncollapse_jump
        set sort_re
        set charset = "utf-8"
        set send_charset = "utf-8:iso-8859-1:us-ascii"
        
        # Pager View Options
        set pager_index_lines = 15
        set pager_context = 3
        set pager_stop
        set menu_scroll
        set tilde
        set abort_key = "<Esc>"     # Set environment variable ESCDELAY=0 to avoid a 1 second delay
        
        # Additional sidebar settings (see whether programs.neomutt.settings works)
        # set sidebar_divider_char = " | "    # Character used as divider between sidebar and panels
        # set sidebar_indent_string = '  '    # Indent mailboxes this amount
        # set sidebar_sort_method = 'unsorted'    # ['unsorted'] Method for sorting the mailboxes
        set mail_check_stats
        
        # color sidebar_divider brightwhite default
        # color sidebar_flagged default default
        # color status brightwhite default

        bind index,pager,browser d noop
        bind index,pager,browser \Cd half-down
        bind index,pager,browser \Cu half-up
        bind pager,index dd delete-message
        bind pager,index u undelete-message
        
        auto_view text/html
        alternative_order text/plain text/enriched text/html
        
        # the programs.neomutt.macros/binds unfortunately doesn't allow for descriptions/helptex. I'll keep most here for now
        macro attach s "<save-entry><bol>$HOME/Downloads/<eol>" "Save to Downloads folder"
        macro index,pager U '<enter-command>set pipe_decode = yes<enter><pipe-message>urlscan<enter><enter-command>set pipe_decode = no<enter>' "view URLs"
        
        # Abook
        set query_command= "abook --config ~/.config/abook/abookrc --datafile ~/.contacts/abook/addressbook-private --mutt-query '%s'"
        macro index,pager a "<pipe-message>abook --config ~/.config/abook/abookrc --datafile ~/.contacts/abook/addressbook-private --add-email-quiet<return>" "Add this sender to Abook"
        
        source /home/ginner/.config/mutt/accounts/1-6inner@gmail.com.muttrc
        macro index,pager i1 '<sync-mailbox><enter-command>source /home/ginner/.config/mutt/accounts/1-6inner@gmail.com.muttrc<enter><change-folder>!<enter>;<check-stats>' "switch to 6inner@gmail.com"
        macro index,pager i2 '<sync-mailbox><enter-command>source /home/ginner/.config/mutt/accounts/2-ginnersjov@gmail.com.muttrc<enter><change-folder>!<enter>;<check-stats>' "switch to ginnersjov@gmail.com"
        
        macro index,pager i3 '<sync-mailbox><enter-command>source /home/ginner/.config/mutt/accounts/3-ginnerskov86@gmail.com.muttrc<enter><change-folder>!<enter>;<check-stats>' "switch to ginnerskov86@gmail.com"
        
        macro index,pager i4 '<sync-mailbox><enter-command>source /home/ginner/.config/mutt/accounts/morten@ginnerskov.com.muttrc<enter><change-folder>!<enter>;<check-stats>' "switch to morten@ginnerskov.com"
        macro index,pager i5 '<sync-mailbox><enter-command>source /home/ginner/.config/mutt/accounts/ginner@startmail.com.muttrc<enter><change-folder>!<enter>;<check-stats>' "switch to ginner@startmail.com"

        ### From mutt-wizard:
        set mime_type_query_command = "file --mime-type -b %s"
set smtp_authenticators = 'gssapi:login'
set rfc2047_parameters = yes
set sleep_time = 0		# Pause 0 seconds for informational messages
set mark_old = no		# Unread mail stay unread until read
set mime_forward = no	# mail body is forwarded as text
set forward_attachments = yes	# attachments are forwarded with mail
set wait_key = no		# mutt won't ask "press key to continue"
set fast_reply			# skip to compose when replying
set fcc_attach			# save attachments with the body
set forward_format = "Fwd: %s"	# format of subject when forwarding
set forward_quote		# include message in forwards
set reverse_name		# reply as whomever it was to
set include			# include message in replies
auto_view application/pgp-encrypted

bind index,pager i noop
bind index,pager g noop
bind index \Cf noop
bind index,pager M noop
bind index,pager C noop
bind editor <space> noop
bind index h noop

# General rebindings
bind index j next-entry
bind index k previous-entry
bind attach <return> view-mailcap
bind attach l view-mailcap
bind pager,attach h exit
bind pager j next-line
bind pager k previous-line
bind pager l view-attachments
bind index L limit
bind index l display-message
bind index,query <space> tag-entry
macro browser h '<change-dir><kill-line>..<enter>' "Go to parent folder"
bind index,pager H view-raw-message
bind browser l select-entry
bind index,pager S sync-mailbox
bind index \031 previous-undeleted	# Mouse wheel
bind index \005 next-undeleted		# Mouse wheel
bind pager \031 previous-line		# Mouse wheel
bind pager \005 next-line		# Mouse wheel

macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
macro index,pager Mi ";<save-message>=INBOX<enter>" "move mail to inbox"
macro index,pager Ci ";<copy-message>=INBOX<enter>" "copy mail to inbox"
macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
macro index,pager Md ";<save-message>=Drafts<enter>" "move mail to drafts"
macro index,pager Cd ";<copy-message>=Drafts<enter>" "copy mail to drafts"
macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"
macro index,pager Mj ";<save-message>=Junk<enter>" "move mail to junk"
macro index,pager Cj ";<copy-message>=Junk<enter>" "copy mail to junk"
macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"
macro index,pager Mt ";<save-message>=Trash<enter>" "move mail to trash"
macro index,pager Ct ";<copy-message>=Trash<enter>" "copy mail to trash"
macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
macro index,pager Ms ";<save-message>=Sent<enter>" "move mail to sent"
macro index,pager Cs ";<copy-message>=Sent<enter>" "copy mail to sent"
macro index,pager ga "<change-folder>=Archive<enter>" "go to archive"
macro index,pager Ma ";<save-message>=Archive<enter>" "move mail to archive"
macro index,pager Ca ";<copy-message>=Archive<enter>" "copy mail to archive"

macro index \eg "<enter-command>unset wait_key<enter><shell-escape>gpg --list-secret-keys; printf 'Enter email ID of user to publish: '; read eID; printf 'Enter fingerprint of GPG key to publish: '; read eFGPT; $prefix/libexec/gpg-wks-client --create \\\$eFGPT \\\$eID | msmtp --read-envelope-from --read-recipients -a $fulladdr<enter>"  "publish GPG key to WKS provider"
macro index \eh "<pipe-message>$prefix/libexec/gpg-wks-client --receive | msmtp --read-envelope-from --read-recipients -a $fulladdr<enter>" "confirm GPG publication"

macro index,pager a "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<return><pipe-message>abook --add-email<return><enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<return>" "add the sender address to abook"
macro index O "<shell-escape>mailsync<enter>" "run mailsync to sync all mail"
macro index \Cf "<enter-command>unset wait_key<enter><shell-escape>printf 'Enter a search term to find with notmuch: '; read x; echo \$x >\"\${XDG_CACHE_HOME:-\$HOME/.cache}/mutt_terms\"<enter><limit>~i \"\`notmuch search --output=messages \$(cat \"\${XDG_CACHE_HOME:-\$HOME/.cache}/mutt_terms\") | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/g for@a; s/\\$/\\\\\\$/g for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern"
macro index A "<limit>all\n" "show all messages (undo limit)"


# I've removed all the mutt-wizard color stuff, in the hopes, that stylix can handle it...
      '';

      extraFiles."mailcap".text = ''
        text/html; ${pkgs.lynx}/bin/lynx -dump -width=120 -stdin; nametemplate=%s.html; copiousoutput
        text/html; ${pkgs.w3m}/bin/w3m -dump -cols 120 -T text/html -I %{charset} -O utf-8; copiousoutput
      '';
    };
  };
}
