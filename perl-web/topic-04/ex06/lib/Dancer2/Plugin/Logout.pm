package Dancer2::Plugin::Logout;
use Dancer2::Plugin;

register logout => sub {
    my $dsl     = shift;
    my $context = $dsl->app->context;
    my $conf    = plugin_setting();

    $context->destroy_session;

    return $context->redirect( '/' );
};

register_plugin for_versions => [ 2 ] ;

1;
