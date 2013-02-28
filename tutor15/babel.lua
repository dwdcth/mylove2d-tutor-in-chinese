--[[

    Babel
    Simple internationalisation tools for LÖVE 2D

    Author : MARTIN Damien
    License : GNU/GPL3+

]]

babel = {}

babel.current_locale  = nil     -- Remember the current locale
babel.locales_folders = {}      -- List of all the folders look in
babel.dictionary      = {}      -- List of all the translations
babel.formats         = {}      -- List of all the formats
babel.debug           = false   -- Display debug informations


--- Init babel with the wished values.
-- @param settings A table with all the needed settings for babel.
babel.init = function( settings )

    babel.current_locale  = settings.locale or "eng-UK"
    babel.locales_folders = settings.locales_folders or { "translations" }
    babel.debug           = settings.debug or false

    babel.switchLocale( babel.current_locale )

end


--- Add a locales folder to the existing list.
-- @param folder The folder to look in.
babel.addLocalesFolder = function( folder )

    table.insert( babel.locales_folders, folder )
    babel.switchLocale() -- Reload current locale

end


--- Change current locale (can be used without parameters to reload current locale).
-- @param locale The locale to use.
babel.switchLocale = function( locale )

    locale = locale or babel.current_locale

    for _, folder in pairs( babel.locales_folders ) do

        if love.filesystem.exists( folder .. "/" .. locale .. ".lua" ) then

            if babel.debug then
                print( "BABEL : Loading " .. folder .. "/" .. locale .. ".lua" )
            end

            babel.current_locale = locale

            chunk = love.filesystem.load( folder .. "/" .. locale .. ".lua" )
            language = chunk()

            babel.formats = babel.mergeTables( babel.formats, language.formats or {} )
            babel.dictionary = babel.mergeTables( babel.dictionary, language.translations or {} )

        end

    end

end


--- Translate a string to the current locale (dynamic texts could be inserted)
-- @param string The text to translate.
-- @param parameters A list of all the dynamic elements in the string
babel.translate = function( string, parameters )

    local parameters = parameters or {}
    local translation = string

    if babel.dictionary[string] ~= nil then
        translation = babel.dictionary[string]
    end

    -- Replace parameters
    for key, value in pairs( parameters ) do
        translation = translation:gsub( "%%" .. key .. "%%", value )
    end

    return translation

end


--- Merge two tables in one. t2 elements will be added to t1 and t2 elements will
-- override existing elements in t2.
-- @param t1 The table who will be used to be merged.
-- @param t2 The tabls who will be merged with.
-- @return The merge tables.
babel.mergeTables = function( t1, t2 )

    for k, v in pairs( t2 ) do
        t1[k] = v
    end

    return t1

end


-- Function shortcut (gettext like)
_ = babel.translate
