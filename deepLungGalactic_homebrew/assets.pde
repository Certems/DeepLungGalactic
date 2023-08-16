PImage opening_graphic = loadImage("");

PImage texture_general_button_back;
PImage texture_general_button_scroller;
PImage texture_flight_selection_probe_selectionBox;
PImage texture_flight_selection_button_launchButton;
PImage texture_flight_controls_thrustCtrl_fwd;
PImage texture_flight_controls_thrustCtrl_bck;
PImage texture_flight_controls_scanSel;
PImage texture_flight_controls_scanEngage;
PImage texture_flight_launch_launchRelease;
PImage texture_flight_mining_drillToggle;
PImage texture_flight_mining_mineralTank;
PImage texture_flight_mining_audioQuick;
PImage texture_flight_mining_mineralQuick;
PImage texture_flight_mining_tempQuick;
PImage texture_flight_mining_transport;
PImage texture_flight_mining_lock;
PImage texture_flight_mining_lockIndicator;
PImage texture_stocks_selection_inv;
PImage texture_stocks_selection_stockDetail;
PImage texture_stocks_selection_stockDetail_commit;
PImage texture_tools_selection_cartographer;
PImage texture_tools_selection_radio;
PImage texture_tools_selection_settings;
PImage texture_tools_cartography_toggleWheel;
PImage texture_tools_cartography_resetZoom;

SoundFile sound_music_music1;
SoundFile sound_music_music2;
SoundFile sound_music_music3;
SoundFile sound_general_button_back;
SoundFile sound_general_click_active;
SoundFile sound_general_click_inactive;
SoundFile sound_general_scroller;
SoundFile sound_flight_probe_launched;
SoundFile sound_flight_probe_destroyed;
SoundFile sound_stocks_commitStaged_active;
SoundFile sound_stocks_commitStaged_inactive;
SoundFile sound_aliens_alien1;
SoundFile sound_aliens_alien2;
SoundFile sound_aliens_alien3;
SoundFile sound_radio_radio1;   //** Likely will have only 1 long radio tune, clicking radio will toggle and jump between points within it

/*
***
Put a graphic on screen explaining the way the game works, 
THEN load so they can read while it loads,
Then allow them to click to enter the main game,
***
*/

void load_textures(){
    load_textures_general();
    load_textures_sensor();
    load_textures_flight();
    load_textures_stocks();
    load_textures_tools();
}

void load_textures_general(){
    texture_general_button_back     = loadImage("button_back.png");
    texture_general_button_scroller = loadImage("button_scroller.png");
    texture_general_button_back.resize(floor(cManager.cFlightControls.backButton_dim.x), floor(cManager.cFlightControls.backButton_dim.y));
    texture_general_button_scroller.resize(floor(cManager.cFlightControls.scroller_dim.x), floor(cManager.cFlightControls.scroller_dim.y));
}

void load_textures_sensor(){
    //pass
}

void load_textures_flight(){
    texture_flight_selection_probe_selectionBox  = loadImage("probe_selectionBox.png"); //Not resized here, resized INSIDE dispCell
    texture_flight_selection_button_launchButton = loadImage("launchButton.png");
    texture_flight_controls_thrustCtrl_fwd       = loadImage("thrustCtrl_fwd.png");
    texture_flight_controls_thrustCtrl_bck       = loadImage("thrustCtrl_bck.png");
    texture_flight_controls_scanSel              = loadImage("scanSel.png");
    texture_flight_controls_scanEngage           = loadImage("scanEngage.png");
    texture_flight_launch_launchRelease          = loadImage("launchRelease.png");
    texture_flight_mining_drillToggle  = loadImage("drillToggle.png");
    texture_flight_mining_mineralTank  = loadImage("mineralTank.png");
    texture_flight_mining_audioQuick   = loadImage("audioQuick.png");
    texture_flight_mining_mineralQuick = loadImage("mineralQuick.png");
    texture_flight_mining_tempQuick    = loadImage("tempQuick.png");
    texture_flight_mining_transport    = loadImage("transportToShip.png");
    texture_flight_mining_lock         = loadImage("lock.png");
    texture_flight_mining_lockIndicator= loadImage("lockIndicator.png");
    texture_flight_selection_button_launchButton.resize(floor(cManager.cFlightControls.launchButton_dim.x), floor(cManager.cFlightControls.launchButton_dim.y));
    texture_flight_controls_thrustCtrl_fwd.resize(floor(cManager.cFlightControls.thrustCtrl_dim.x), floor(cManager.cFlightControls.thrustCtrl_dim.y));
    texture_flight_controls_thrustCtrl_bck.resize(floor(cManager.cFlightControls.thrustCtrl_dim.x), floor(cManager.cFlightControls.thrustCtrl_dim.y));
    texture_flight_controls_scanSel.resize(floor(cManager.cFlightControls.scanSel_dim.x), floor(cManager.cFlightControls.scanSel_dim.y));
    texture_flight_controls_scanEngage.resize(floor(cManager.cFlightControls.scanEngage_dim.x), floor(cManager.cFlightControls.scanEngage_dim.y));
    texture_flight_launch_launchRelease.resize(floor(cManager.cFlightControls.launchRelease_dim.x), floor(cManager.cFlightControls.launchRelease_dim.y));
    texture_flight_mining_drillToggle.resize(floor(cManager.cFlightControls.drillToggle_dim.x), floor(cManager.cFlightControls.drillToggle_dim.y));
    texture_flight_mining_mineralTank.resize(floor(cManager.cFlightControls.mineralTank_dim.x), floor(cManager.cFlightControls.mineralTank_dim.y));
    texture_flight_mining_audioQuick.resize(floor(cManager.cFlightControls.audioQuick_dim.x), floor(cManager.cFlightControls.audioQuick_dim.y));
    texture_flight_mining_mineralQuick.resize(floor(cManager.cFlightControls.mineralQuick_dim.x), floor(cManager.cFlightControls.mineralQuick_dim.y));
    texture_flight_mining_tempQuick.resize(floor(cManager.cFlightControls.tempQuick_dim.x), floor(cManager.cFlightControls.tempQuick_dim.y));
    texture_flight_mining_transport.resize(floor(cManager.cFlightControls.transport_dim.x), floor(cManager.cFlightControls.transport_dim.y));
    texture_flight_mining_lock.resize(floor(cManager.cFlightControls.lock_dim.x), floor(cManager.cFlightControls.lock_dim.y));
    texture_flight_mining_lockIndicator.resize(floor(cManager.cFlightControls.lockIndicator_dim.x), floor(cManager.cFlightControls.lockIndicator_dim.y));
}

void load_textures_stocks(){
    texture_stocks_selection_inv                = loadImage("inventory_selectionBox.png");
    texture_stocks_selection_stockDetail        = loadImage("commitDetails.png");
    texture_stocks_selection_stockDetail_commit = loadImage("commitButton.png");
    texture_stocks_selection_inv.resize(floor(cManager.cStockRecords.inv_dim.x), floor(2.0*cManager.cStockRecords.inv_dim.y));         //##### PUT A *2 FOR MORE CLARITY ######
    texture_stocks_selection_stockDetail.resize(floor(cManager.cStockRecords.stockDetail_dim.x), floor(cManager.cStockRecords.stockDetail_dim.y));
    texture_stocks_selection_stockDetail_commit.resize(floor(cManager.cStockRecords.stockDetail_commit_dim.x), floor(cManager.cStockRecords.stockDetail_commit_dim.y));
}

void load_textures_tools(){
    texture_tools_selection_cartographer = loadImage("cartography.png");
    texture_tools_selection_radio        = loadImage("radio.png");
    texture_tools_selection_settings     = loadImage("settings.png");
    texture_tools_cartography_toggleWheel= loadImage("toggleCartoWheel.png");
    texture_tools_cartography_resetZoom  = loadImage("resetZoom.png");
    texture_tools_selection_cartographer.resize(floor(cManager.cToolArray.cartographer_dim.x), floor(cManager.cToolArray.cartographer_dim.y));
    texture_tools_selection_radio.resize(floor(cManager.cToolArray.radio_dim.x), floor(cManager.cToolArray.radio_dim.y));
    texture_tools_selection_settings.resize(floor(cManager.cToolArray.settings_dim.x), floor(cManager.cToolArray.settings_dim.y));
    texture_tools_cartography_toggleWheel.resize(floor(cManager.cToolArray.wheelLoad_dim.x), floor(cManager.cToolArray.wheelLoad_dim.y));
    texture_tools_cartography_resetZoom.resize(floor(cManager.cToolArray.zoomOutButton_dim.x), floor(cManager.cToolArray.zoomOutButton_dim.y));
}




void load_sounds(){
    load_sounds_music();
    load_sounds_general();
    load_sounds_sensor();
    load_sounds_flight();
    load_sounds_stocks();
    load_sounds_tools();
    load_sounds_aliens();
    load_sounds_radio();
}

void load_sounds_music(){
    sound_music_music1 = new SoundFile(this, "background_1.wav");       //## SHOULD MOVE ALL TO MP3 --> SMALLER FILE SIZE FOR LARGER AUDIO LENGTHS
    sound_music_music2 = new SoundFile(this, "background_1.wav");       //##
    sound_music_music3 = new SoundFile(this, "background_1.wav");       //##
}

void load_sounds_general(){
    sound_general_button_back    = new SoundFile(this, "button_back.wav");
    sound_general_click_active   = new SoundFile(this, "button_generalClick_active.wav");
    sound_general_click_inactive = new SoundFile(this, "button_generalClick_inactive.wav");
    sound_general_scroller       = new SoundFile(this, "button_scroller.wav");
}

void load_sounds_sensor(){
    //pass
}

void load_sounds_flight(){
    sound_flight_probe_launched  = new SoundFile(this, "probe_launched.wav");
    sound_flight_probe_destroyed = new SoundFile(this, "probe_destroyed.wav");
}

void load_sounds_stocks(){
    sound_stocks_commitStaged_active   = new SoundFile(this, "button_commitStaged_active.wav");
    sound_stocks_commitStaged_inactive = new SoundFile(this, "button_commitStaged_inactive.wav");
}

void load_sounds_tools(){
    //pass
}

void load_sounds_aliens(){
    sound_aliens_alien1 = new SoundFile(this, "aliens_1.wav");
    sound_aliens_alien2 = new SoundFile(this, "aliens_1.wav");
    sound_aliens_alien3 = new SoundFile(this, "aliens_1.wav");
}

void load_sounds_radio(){
    //## MEMORY HEAVY ATM => TEMP. REMOVING AUDIO FROM PROJECT
    sound_radio_radio1 = new SoundFile(this, "aliens_1.wav");//new SoundFile(this, "Radio Chatter - W1ZY April 29th, 2019.m4a");
}