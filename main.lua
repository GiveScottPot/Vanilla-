-- Vanilla+ v1.2.2 compatibility hotfix for Gen1Recomp++ 0.2.56+
-- Native-style hidden-stat page for Pokémon summaries.
-- A/B: Stats -> Hidden Stats -> Moves -> close
-- SELECT on Hidden Stats: DVs <-> Stat Exp

return function(mod)
  mod.options:define({
    {
      key = "dv_summary",
      label = "HIDDEN STATS PAGE",
      type = "toggle",
      default = true,
      description = "Adds a detailed stat page to Pokemon summaries. Press SELECT on that page to switch views.",
      help = "Adds a detailed stat page to Pokemon summaries. Press SELECT on that page to switch views.",
    },
    {
      key = "version_exclusives",
      label = "R/B EXCLUSIVES",
      type = "toggle",
      default = false,
      description = "Adds the other Red/Blue version-exclusive Pokemon to fitting habitats. Does not add Yellow-only placements. Restart required.",
      help = "Adds the other Red/Blue version-exclusive Pokemon to fitting habitats. Does not add Yellow-only placements. Restart required.",
    },
    {
      key = "wild_fossils",
      label = "WILD FOSSILS",
      type = "toggle",
      default = false,
      description = "Adds rare fossil Pokemon to late-game cave habitats, including AERODACTYL in CERULEAN CAVE. Restart required.",
      help = "Adds rare fossil Pokemon to late-game cave habitats, including AERODACTYL in CERULEAN CAVE. Restart required.",
    },
    {
      key = "running_shoes",
      label = "RUNNING SHOES",
      type = "toggle",
      default = true,
      description = "Hold B while walking to run. Bike and Surf movement are unchanged.",
      help = "Hold B while walking to run. Bike and Surf movement are unchanged.",
    },
    {
      key = "field_shortcuts",
      label = "FIELD SHORTCUTS",
      type = "toggle",
      default = true,
      description = "Press A at water or CUT trees to use available field actions.",
      help = "Press A at water or CUT trees to use available field actions.",
    },
    {
      key = "battle_exp_bar",
      label = "BATTLE EXP BAR",
      type = "toggle",
      default = true,
      description = "Shows your active Pokemon's progress toward its next level during battle.",
      help = "Shows your active Pokemon's progress toward its next level during battle.",
    },
    {
      key = "caught_indicator",
      label = "CAUGHT INDICATOR",
      type = "toggle",
      default = true,
      description = "Marks wild Pokemon species already registered as caught.",
      help = "Marks wild Pokemon species already registered as caught.",
    },
    {
      key = "yellow_route_encounters",
      label = "ALL-CART ENCOUNTERS",
      type = "toggle",
      default = false,
      description = "Combines Red, Blue, and Yellow encounter availability while keeping the current cart as the base. Restart required.",
      help = "Combines Red, Blue, and Yellow encounter availability while keeping the current cart as the base. Restart required.",
    },
    {
      key = "repel_reuse_prompt",
      label = "REPEL PROMPT",
      type = "toggle",
      default = true,
      description = "When REPEL wears off, asks whether to use another and lets you choose among the Repel types you carry.",
      help = "When REPEL wears off, asks whether to use another and lets you choose among the Repel types you carry.",
    },
    {
      key = "indoor_teleport",
      label = "INDOOR TELEPORT",
      type = "toggle",
      default = false,
      description = "Lets TELEPORT work from more indoor and enclosed areas while keeping its normal destination behavior.",
      help = "Lets TELEPORT work from more indoor and enclosed areas while keeping its normal destination behavior.",
    },
    {
      key = "fly_to_centers",
      label = "EXPANDED FLY",
      type = "toggle",
      default = true,
      description = "Expands FLY to additional useful destinations after they are discovered.",
      help = "Expands FLY to additional useful destinations after they are discovered.",
    },
    {
      key = "bill_trade_machine",
      label = "TRADE EVOLUTION",
      type = "toggle",
      default = false,
      description = "Adds an optional postgame method for evolving Pokemon that normally require trading.",
      help = "Adds an optional postgame method for evolving Pokemon that normally require trading.",
    },
    {
      key = "center_chansey",
      label = "POKEMON CENTER CHANSEY",
      type = "toggle",
      default = false,
      description = "Adds an interactable CHANSEY beside NURSE JOY with contextual reactions.",
      help = "Adds an interactable CHANSEY beside NURSE JOY with contextual reactions.",
    },
    {
      key = "tm_move_names",
      label = "TM MOVE NAMES",
      type = "toggle",
      default = true,
      description = "Shows the taught move in every TM name, such as TM24 THUNDERBOLT, in the Bag and PC.",
      help = "Shows the taught move in every TM name, such as TM24 THUNDERBOLT, in the Bag and PC.",
    },
    {
      key = "tm_marts",
      label = "TM MARTS",
      type = "toggle",
      default = true,
      description = "Adds themed post-Champion TM stock to Kanto marts and gives mart BUY/SELL lists tighter spacing for long item names.",
      help = "Adds themed post-Champion TM stock to Kanto marts and gives mart BUY/SELL lists tighter spacing for long item names.",
    },
    {
      key = "reusable_tms",
      label = "REUSABLE TMS",
      type = "toggle",
      default = false,
      description = "Makes TMs reusable after a successful teach. HMs remain reusable as normal.",
      help = "Makes TMs reusable after a successful teach. HMs remain reusable as normal.",
    },
    {
      key = "permanent_cut_trees",
      label = "PERMANENT CUT TREES",
      type = "toggle",
      default = true,
      description = "Trees cut down stay cleared instead of growing back after a map change.",
      help = "Trees cut down stay cleared instead of growing back after a map change.",
    },
    {
      key = "adventurers_toolkit",
      label = "ADVENTURER TOOLKIT",
      type = "toggle",
      default = true,
      description = "Adds a postgame field-tool system that consolidates useful exploration gear and shortcuts.",
      help = "Adds a postgame field-tool system that consolidates useful exploration gear and shortcuts.",
    },
    {
      key = "postgame_mimey",
      label = "POSTGAME MR MIME",
      type = "toggle",
      default = true,
      description = "Adds a small postgame change to RED's home.",
      help = "Adds a small postgame change to RED's home.",
    },
    {
      key = "oak_postdex_life",
      label = "NPC ADDITIONAL DIALOGUE",
      type = "toggle",
      default = true,
      description = "Adds optional extra dialogue to select NPCs after relevant story milestones.",
      help = "Adds optional extra dialogue to select NPCs after relevant story milestones.",
    },
  })

  -- Vanilla+ option help ----------------------------------------------------
  do
    local ManagerState = require("src.mods.ManagerState")
    local Font = require("src.render.Font")
    local TextBox = require("src.render.TextBox")

    if not ManagerState._vanillaPlusOptionInfoPatched then
      ManagerState._vanillaPlusOptionInfoPatched = true

      local originalUpdateOptions = ManagerState.updateOptions
      function ManagerState:updateOptions(input)
        if self.currentMod and self.currentMod.id == "vanillaplus"
          and input:wasPressed("select") then
          local rows = self.optionRows or {}
          local focused = rows[self.cursor]
          local schema = self:schemaFor(self.currentMod) or {}
          if focused and focused.id and focused.id ~= "__reset" then
            for _, def in ipairs(schema) do
              if type(def) == "table" and def.key == focused.id then
                local text = def.description or def.help
                if text and text ~= "" then
                  self.game.stack:push(TextBox.new(self.game, text))
                else
                  self:notify("NO DESCRIPTION")
                end
                return
              end
            end
          end
        end
        return originalUpdateOptions(self, input)
      end

      local originalDraw = ManagerState.draw
      function ManagerState:draw()
        originalDraw(self)
        if self.screen == "options" and self.currentMod
          and self.currentMod.id == "vanillaplus" then
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.rectangle("fill", 0, 128, 160, 16)
          love.graphics.setColor(0, 0, 0, 1)
          Font.draw("SELECT:INFO  B:DONE", 8, 136)
          love.graphics.setColor(1, 1, 1, 1)
        end
      end
    end
  end


  -- Experimental encounter preview.
  --
  -- For the four closely mirrored Red/Blue exclusive families, if an encounter
  -- table contains at least two slots of one counterpart and none of the other,
  -- replace the final duplicate slot with the missing counterpart. The original
  -- level and overall slot count remain unchanged.
  --
  -- This intentionally excludes Scyther/Pinsir and Electabuzz/Magmar until their
  -- habitat placement receives separate design approval.
  local function applyVersionExclusivePreview()
    if not (mod.options:get("version_exclusives") or mod.options:get("yellow_route_encounters")) then
      return
    end

    local pairs = {
      { "EKANS", "SANDSHREW" },
      { "ODDISH", "BELLSPROUT" },
      { "MANKEY", "MEOWTH" },
      { "GROWLITHE", "VULPIX" },
      { "SCYTHER", "PINSIR" },
      { "ELECTABUZZ", "MAGMAR" },
    }

    local patchedTables = 0
    local addedSlots = 0

    local function copySlots(slots)
      local out = {}
      for i, slot in ipairs(slots or {}) do
        out[i] = { level = slot.level, species = slot.species }
      end
      return out
    end

    local function addMissingCounterparts(slots)
      if type(slots) ~= "table" then
        return nil, 0
      end

      local updated = copySlots(slots)
      local changes = 0

      local function indicesFor(species)
        local out = {}
        for index, slot in ipairs(updated) do
          if slot.species == species then
            out[#out + 1] = index
          end
        end
        return out
      end

      local function findSacrificialDuplicate(excludedA, excludedB)
        local seen = {}
        for index = #updated, 1, -1 do
          local s = updated[index].species
          if s ~= excludedA and s ~= excludedB then
            if seen[s] then
              return index
            end
            seen[s] = true
          end
        end
        return nil
      end

      for _, pair in ipairs(pairs) do
        local first, second = pair[1], pair[2]
        local firstIndices = indicesFor(first)
        local secondIndices = indicesFor(second)

        local presentSpecies, missingSpecies
        if #firstIndices > 0 and #secondIndices == 0 then
          presentSpecies, missingSpecies = first, second
        elseif #secondIndices > 0 and #firstIndices == 0 then
          presentSpecies, missingSpecies = second, first
        end

        if missingSpecies then
          local presentIndices = indicesFor(presentSpecies)
          local replacementIndex

          -- Prefer consuming a duplicate of the already-present counterpart.
          if #presentIndices >= 2 then
            replacementIndex = presentIndices[#presentIndices]
          else
            -- Otherwise preserve the original exclusive and replace another
            -- duplicated encounter slot in the same habitat.
            replacementIndex = findSacrificialDuplicate(first, second)
          end

          if replacementIndex then
            updated[replacementIndex].species = missingSpecies
            changes = changes + 1
          end
        end
      end

      if changes == 0 then
        return nil, 0
      end
      return updated, changes
    end


    for id, encounter in mod.content.encounters:each() do
      local patch = {}
      local changed = false
      local normalized = tostring(id or ""):upper():gsub("[^A-Z0-9]+", "_")

      for _, kind in ipairs({ "grass", "water" }) do
        local tableDef = encounter[kind]
        if tableDef and type(tableDef.slots) == "table" then
          local slots, changes = addMissingCounterparts(tableDef.slots)
          if slots then
            patch[kind] = {
              rate = tableDef.rate,
              slots = slots,
            }
            changed = true
            addedSlots = addedSlots + changes
          end
        end
      end

      -- Yellow removes the Weedle family from normal play.  Restore Weedle
      -- specifically to Viridian Forest by replacing a duplicate grass slot;
      -- this keeps the original encounter count and level curve intact.
      if normalized:find("VIRIDIAN_FOREST", 1, true)
          and encounter.grass and type(encounter.grass.slots) == "table" then
        local hasWeedle = false
        for _, slot in ipairs((patch.grass and patch.grass.slots) or encounter.grass.slots) do
          if slot.species == "WEEDLE" then hasWeedle = true break end
        end
        if not hasWeedle then
          local source = (patch.grass and patch.grass.slots) or copySlots(encounter.grass.slots)
          local counts = {}
          for _, slot in ipairs(source) do counts[slot.species] = (counts[slot.species] or 0) + 1 end
          for index = #source, 1, -1 do
            if counts[source[index].species] and counts[source[index].species] > 1 then
              source[index].species = "WEEDLE"
              patch.grass = { rate = encounter.grass.rate, slots = source }
              changed = true
              addedSlots = addedSlots + 1
              break
            end
          end
        end
      end

      if changed then
        mod.content.encounters:patch(id, patch)
        patchedTables = patchedTables + 1
      end
    end

    mod.log:info(
      "version-exclusive preview patched %d encounter tables (%d counterpart slots)",
      patchedTables,
      addedSlots
    )
  end

  applyVersionExclusivePreview()

  local function applyWildFossils()
    if not mod.options:get("wild_fossils") then
      return
    end

    local function normalizedId(id)
      return tostring(id or ""):lower():gsub("[^a-z0-9]+", "")
    end

    local function copySlots(slots)
      local out = {}
      for i, slot in ipairs(slots or {}) do
        out[i] = { level = slot.level, species = slot.species }
      end
      return out
    end

    local function injectSpecies(slots, wanted)
      if type(slots) ~= "table" or #slots == 0 then
        return nil
      end

      local updated = copySlots(slots)
      local present = {}
      for _, slot in ipairs(updated) do
        present[slot.species] = true
      end

      local missing = {}
      for _, species in ipairs(wanted) do
        if not present[species] then
          missing[#missing + 1] = species
        end
      end
      if #missing == 0 then
        return nil
      end

      -- Prefer replacing repeated species, starting from the rarest/end slots.
      local counts = {}
      for _, slot in ipairs(updated) do
        counts[slot.species] = (counts[slot.species] or 0) + 1
      end

      local replaceable = {}
      for index = #updated, 1, -1 do
        local species = updated[index].species
        if counts[species] and counts[species] > 1 then
          replaceable[#replaceable + 1] = index
          counts[species] = counts[species] - 1
        end
      end

      if #replaceable < #missing then
        return nil
      end

      for i, species in ipairs(missing) do
        updated[replaceable[i]].species = species
      end
      return updated
    end

    local patched = 0

    for id, encounter in mod.content.encounters:each() do
      local key = normalizedId(id)
      local wanted

      -- Gen1Recomp encounter ids are expected to retain recognizable map names.
      -- Keep the matcher broad enough to tolerate underscore/case differences,
      -- while restricting fossils to the intended deepest maps.
      if key:find("seafoam") and (key:find("b4") or key:find("4f") or key:find("floor4")) then
        wanted = { "OMANYTE", "KABUTO" }
      elseif key:find("cerulean") and key:find("cave")
        and (key:find("b1") or key:find("basement") or key:find("floorb1")) then
        wanted = { "OMASTAR", "KABUTOPS" }
      end

      if wanted then
        for _, groupName in ipairs({ "water", "surf", "surfing" }) do
          local group = encounter[groupName]
          if group and type(group.slots) == "table" then
            local slots = injectSpecies(group.slots, wanted)
            if slots then
              mod.content.encounters:patch(id, {
                [groupName] = { rate = group.rate, slots = slots },
              })
              patched = patched + 1
              mod.log:info("Vanilla+ wild fossil %s encounters patched %s", groupName, tostring(id))
            end
          end
        end
      end
    end

    mod.log:info("Vanilla+ wild fossil option patched %d cave tables", patched)
  end

  applyWildFossils()


  local function applyYellowRouteEncounters()
    if not mod.options:get("yellow_route_encounters") then return end

    local function copySlots(slots)
      local out = {}
      for i, slot in ipairs(slots or {}) do
        out[i] = { level = slot.level, species = slot.species }
      end
      return out
    end

    local function normalized(id)
      return tostring(id or ""):upper():gsub("[^A-Z0-9]+", "_")
    end

    -- Yellow-route placements are deliberately separate from the broader
    -- version-exclusive merge.  Patch a known weighted slot directly instead
    -- of requiring a duplicated species; this avoids silently doing nothing on
    -- tables whose ten slots happen to all be distinct.
    local patched = 0
    for id, encounter in mod.content.encounters:each() do
      local key = normalized(id)
      local grass = encounter.grass
      if grass and type(grass.slots) == "table" and #grass.slots >= 10 then
        local slots = copySlots(grass.slots)
        local changed = false
        if key == "ROUTE_22" or key:find("ROUTE_22", 1, true) then
          local has = false
          for _, slot in ipairs(slots) do if slot.species == "MANKEY" then has = true break end end
          if not has then
            -- Slot 6 is a 10%% Gen-I bucket in the standard table: uncommon
            -- enough to feel like a Yellow placement without becoming a hunt.
            slots[6].species = "MANKEY"
            changed = true
          end
        elseif key == "VIRIDIAN_FOREST" or key:find("VIRIDIAN_FOREST", 1, true) then
          local has = false
          for _, slot in ipairs(slots) do if slot.species == "PIDGEOTTO" then has = true break end end
          if not has then
            -- Keep Pidgeotto genuinely rare by using the final 1%% bucket.
            slots[10].species = "PIDGEOTTO"
            changed = true
          end
        end
        if changed then
          mod.content.encounters:patch(id, {
            grass = { rate = grass.rate, buckets = grass.buckets, slots = slots },
          })
          patched = patched + 1
        end
      end
    end
    mod.log:info("Vanilla+ Yellow route encounters patched %d tables", patched)
  end

  applyYellowRouteEncounters()

  local function applyExpandedEncounters()
    if not mod.options:get("expanded_encounters") then return end

    local function copySlots(slots)
      local out = {}
      for i, slot in ipairs(slots or {}) do out[i] = { level = slot.level, species = slot.species } end
      return out
    end

    local function addToGrass(id, encounter, species)
      if not encounter.grass or type(encounter.grass.slots) ~= "table" then return false end
      local slots = copySlots(encounter.grass.slots)
      for _, slot in ipairs(slots) do if slot.species == species then return false end end
      local counts = {}
      for _, slot in ipairs(slots) do counts[slot.species] = (counts[slot.species] or 0) + 1 end
      for index = #slots, 1, -1 do
        if counts[slots[index].species] and counts[slots[index].species] > 1 then
          slots[index].species = species
          mod.content.encounters:patch(id, { grass = { rate = encounter.grass.rate, slots = slots } })
          return true
        end
      end
      return false
    end

    local patched = 0
    for id, encounter in mod.content.encounters:each() do
      local key = tostring(id or ""):upper():gsub("[^A-Z0-9]+", "_")
      -- Expanded encounters intentionally stays separate from Yellow's
      -- version-specific route placements. Add future ecology entries here.
    end
    mod.log:info("Vanilla+ expanded encounters patched %d restrained route tables", patched)
  end

  applyExpandedEncounters()

  -- Running shoes: use the engine's supported movement-speed hook rather than
  -- replacing Player movement. Holding B while on foot halves the current
  -- step duration; bike and Surf retain their native timing.
  mod.hooks:wrap("movement.speed", function(next, frames, ctx)
    frames = next(frames, ctx)
    if not mod.options:get("running_shoes")
      or not mod.save:get("running_shoes_received_v2") then
      return frames
    end
    if ctx and not ctx.onBike and not ctx.surfing
      and ctx.input and ctx.input:isDown("b") then
      return math.max(1, math.floor(frames / 2))
    end
    return frames
  end)

  -- Context-sensitive A-button field actions.  world.interacted fires only
  -- after the normal interaction resolver has had first refusal; we act on
  -- kind="none" so NPCs, signs, doors, hidden items and scripts stay vanilla.
  local gameRef
  mod.events:on("game.ready", function(ev) gameRef = ev and ev.game end)

  -- Vanilla+ custom dialogue formatter ------------------------------------
  -- Gen1Recomp dialogue boxes have an 18-glyph line budget.  Earlier
  -- Vanilla+ NPC text hand-authored conservative \n breaks, which produced
  -- awkward orphan words and excessive whitespace at slow text speed.
  -- Keep authored form-feed (\f) beats, but reflow the text inside each
  -- beat to the real 18-column width so the native TextBox can scroll/page
  -- naturally just like base-game dialogue.
  local function vpFormatDialogue(text)
    text = tostring(text or "")
    local pages = {}
    for page in (text .. "\f"):gmatch("(.-)\f") do
      -- Recomp 0.2.56 already performs width-aware soft wrapping. Vanilla+
      -- should only remove legacy hand-authored line/scroll breaks and preserve
      -- deliberate form-feed page beats. Injecting \v here forces an A press
      -- between otherwise natural wrapped lines, which caused the recent
      -- Bill/Mom/Mr. Mime/Axe choppy-pagination regression.
      page = page:gsub("[\r\n\v]+", " ")
                 :gsub("%s+", " ")
                 :gsub("^%s+", "")
                 :gsub("%s+$", "")
      if page ~= "" then pages[#pages + 1] = page end
    end
    if #pages == 0 then return "" end
    return table.concat(pages, "\f")
  end




  -- Trainer Dialogue Framework — Route 8 Lass Champion test20 --------------------------------------
  -- Route 8 Lass three-state Champion dialogue test.
  --
  -- Stop guessing her object index/party. The only identity signal already
  -- proven by QA is her unique challenge text. We therefore chain the actual
  -- trainer lifecycle:
  --
  -- world.trainer_engaged -> remember the real NPC
  -- proven pre-battle TextBox -> identify that remembered NPC as our target
  -- trainer.before_battle -> arm the exact encounter
  -- battle.started -> replace that battle's endBattleText directly
  -- defeated talkTo -> replace re-talk by the remembered NPC id
  do
    local TextBox = require("src.render.TextBox")
    local okOW, OverworldState = pcall(require, "src.world.OverworldController")

    local function lassPlayerName()
      local save = gameRef and gameRef.save
      local player = save and save.player
      return (player and player.name) or "RED"
    end

    local function lassPreText()
      return "Oh my gosh, it's CHAMPION " .. lassPlayerName()
        .. "! My WIGGLYTUFFS have been itching for payback!"
    end

    local lassDefeatText = "This is just\nlike last time?!"

    local function lassAfterText()
      return "You truly are one of the best to ever do it, "
        .. lassPlayerName() .. "."
    end

    local function championReady()
      local flags = gameRef and gameRef.save and gameRef.save.flags or {}
      return flags.EVENT_BEAT_CHAMPION_RIVAL and true or false
    end

    local lastEngaged = nil
    local armedBattle = nil

    local function cleanForMatch(text)
      if type(text) ~= "string" then return "" end
      local t = text:gsub("[%z\1-\31]", " ")
      t = t:gsub("%s+", " ")
      return t:lower()
    end

    local function rememberTarget(info)
      if not info then return end
      gameRef.save.vpRoute8LassNpcId = info.npcId
      gameRef.save.vpRoute8LassMapId = info.mapId
      gameRef.save.vpRoute8LassClass = info.trainerClass
      gameRef.save.vpRoute8LassParty = info.partyIndex
      mod.log:info("v1.2.1-test31 Lass IDENTIFIED npc="
        .. tostring(info.npcId) .. " map=" .. tostring(info.mapId)
        .. " class=" .. tostring(info.trainerClass)
        .. " party=" .. tostring(info.partyIndex))
    end

    local function isRememberedTarget(ow, npc)
      if not ow or not npc then return false end
      return gameRef.save.vpRoute8LassNpcId ~= nil
         and npc.id == gameRef.save.vpRoute8LassNpcId
         and tostring(ow.map.id) == tostring(gameRef.save.vpRoute8LassMapId)
    end

    -- First capture whichever real trainer NPC the engine is engaging.
    mod.events:on("world.trainer_engaged", function(ev)
      local ow = gameRef and gameRef.overworld
      local npc = ev and ev.npc
      if not ow or not npc then return end
      lastEngaged = {
        npcId = npc.id,
        mapId = ow.map and ow.map.id,
        trainerClass = ev.trainerClass or (npc.def and npc.def.trainerClass),
        partyIndex = ev.partyIndex or (npc.def and npc.def.trainerParty) or 1,
      }
      mod.log:info("v1.2.1-test20 trainer engaged candidate npc="
        .. tostring(lastEngaged.npcId))
    end)

    -- State 1: proven hook. Matching this unique challenge text is what
    -- officially identifies the previously remembered real NPC as our Lass.
    if TextBox and type(TextBox.new) == "function"
       and not TextBox._vanillaPlusRoute8LassPreTest20 then
      local nativeTextBoxNew = TextBox.new
      TextBox.new = function(game, text, onDone, opts)
        if type(text) == "string" then
          local t = cleanForMatch(text)
          if championReady() and t:find("cute, round and fluffy", 1, true) then
            rememberTarget(lastEngaged)
            text = vpFormatDialogue(lassPreText())
            mod.log:info("v1.2.1-test31 Lass PRE hook hit")
          end
        end
        return nativeTextBoxNew(game, text, onDone, opts)
      end
      TextBox._vanillaPlusRoute8LassPreTest20 = true
    end

    -- Progressive Leveling prototype (test31) -------------------------------
    -- The exact Route 8 Lass is our guinea pig for the global post-Champion
    -- trainer architecture:
    --   highest player level 55-60 -> 3 mons
    --                        61-69 -> 4 mons
    --                        70-79 -> 5 mons
    --                        80+   -> 6 mons
    -- Postgame trainer levels have a hard floor of 55 and are distributed
    -- around the player's highest party level instead of being identical.
    --
    -- Each ordinary trainer will ultimately own one curated permanent
    -- six-Pokemon pool. Runtime code only chooses how much of that pool is
    -- active and applies the level spread. For this Lass, Clefable is the
    -- signature ace because her vanilla identity is built around Clefairy.
    local lassProgressivePool = {
      { species = "WIGGLYTUFF",
        moves = { "BODY_SLAM", "SING", "REST", "DOUBLE_EDGE" } },
      { species = "CHANSEY",
        moves = { "SEISMIC_TOSS", "THUNDER_WAVE", "SOFTBOILED", "REFLECT" } },
      { species = "NIDOQUEEN",
        moves = { "EARTHQUAKE", "BODY_SLAM", "TOXIC", "FISSURE" } },
      { species = "NIDOKING",
        moves = { "EARTHQUAKE", "ROCK_SLIDE", "BODY_SLAM", "FISSURE" } },
      { species = "SNORLAX",
        moves = { "BODY_SLAM", "REST", "AMNESIA", "FISSURE" } },
      { species = "CLEFABLE",
        moves = { "PSYCHIC", "THUNDER_WAVE", "BODY_SLAM", "SOFTBOILED" },
        ace = true },
    }

    local function highestPlayerPartyLevel()
      local highest = 0
      local party = gameRef and gameRef.save and gameRef.save.party or {}
      for _, mon in ipairs(party) do
        local lv = tonumber(mon and mon.level) or 0
        if lv > highest then highest = lv end
      end
      return highest
    end

    local function progressivePartySize(highest)
      if highest >= 80 then return 6 end
      if highest >= 70 then return 5 end
      if highest >= 61 then return 4 end
      return 3 -- post-Champion floor covers 55-60 and any lower test save
    end

    local progressiveOffsets = {
      [3] = { -2,  0,  2 },
      [4] = { -3, -1,  0,  2 }, -- Lv61 -> 58/60/61/63
      [5] = { -3, -2,  0,  1,  2 },
      [6] = { -3, -2, -1,  0,  1,  2 },
    }

    local function scaledLevel(highest, offset)
      local lv = highest + offset
      if lv < 55 then lv = 55 end
      if lv > 100 then lv = 100 end
      return lv
    end

    local function buildLassProgressiveParty()
      local highest = highestPlayerPartyLevel()
      -- Champion-side scaling never treats the reference as below 55.
      if highest < 55 then highest = 55 end

      local count = progressivePartySize(highest)
      local offsets = progressiveOffsets[count]
      local selected = {}

      -- Select from the permanent six in a stable progression order while
      -- always preserving the ace. This makes the first test deterministic.
      -- Later the same engine can use curated per-trainer slot priorities or
      -- controlled variety without changing the scaler itself.
      local nonAceCount = count - 1
      for i = 1, nonAceCount do
        selected[#selected + 1] = lassProgressivePool[i]
      end
      selected[#selected + 1] = lassProgressivePool[6] -- Clefable ace

      local out = {}
      for i, row in ipairs(selected) do
        out[#out + 1] = {
          species = row.species,
          level = scaledLevel(highest, offsets[i]),
          moves = row.moves,
        }
      end

      mod.log:info("v1.2.1-test31 Progressive Lass highest="
        .. tostring(highest) .. " count=" .. tostring(count))
      for i, row in ipairs(out) do
        mod.log:info("v1.2.1-test31 slot" .. tostring(i) .. "="
          .. tostring(row.species) .. " Lv" .. tostring(row.level))
      end
      return out
    end

    if mod.hooks then
      mod.hooks:wrap("trainer.party", function(next, trainerClass, partyIndex, party)
        local out = next(trainerClass, partyIndex, party)
        if championReady()
           and gameRef.save.vpRoute8LassClass ~= nil
           and trainerClass == gameRef.save.vpRoute8LassClass
           and (partyIndex or 1) == (gameRef.save.vpRoute8LassParty or 1) then
          return buildLassProgressiveParty()
        end
        return out
      end)
    end

    -- Arm only the encounter whose real npcId/mapId were learned above.
    if mod.hooks then
      mod.hooks:wrap("trainer.before_battle",
        function(next, game, context, continue)
          if championReady()
             and context
             and gameRef.save.vpRoute8LassNpcId ~= nil
             and context.npcId == gameRef.save.vpRoute8LassNpcId
             and tostring(context.mapId) == tostring(gameRef.save.vpRoute8LassMapId) then
            armedBattle = {
              trainerClass = context.trainerClass,
              partyIndex = context.partyIndex,
              npcId = context.npcId,
              mapId = context.mapId,
            }
            mod.log:info("v1.2.1-test31 Lass BEFORE_BATTLE armed")
          end
          return next(game, context, continue)
        end)
    end

    -- State 2: battle.started gives us the live BattleState. Set the final
    -- trainer-loss line directly on that live battle, after construction but
    -- long before victory consumes it.
    mod.events:on("battle.started", function(ev)
      local battle = ev and ev.battle
      if not championReady() or not battle or not armedBattle then return end
      if battle.kind ~= "trainer" then return end
      if battle.oppClass ~= armedBattle.trainerClass
         or (battle.partyIndex or 1) ~= (armedBattle.partyIndex or 1) then
        return
      end

      battle.endBattleText = lassDefeatText
      battle._vpRoute8LassNpcId = armedBattle.npcId
      battle._vpRoute8LassMapId = armedBattle.mapId
      -- Real finite diagnostic bag. These counts live only for this battle.
      battle._vpLassInventory = {
        MAX_REVIVE = 1,
        REVIVE = 2,
        FULL_RESTORE = 2,
        X_ACCURACY = 3,
        X_ATTACK = 1,
        FULL_HEAL = 1,
      }
      mod.log:info("v1.2.1-test31 Lass DEFEAT + finite item bag armed")
      armedBattle = nil
    end)

    -- State 3: use the exact NPC id learned from the working challenge hook.
    -- No trainer index, class, party or dialogue substring guessing here.
    if okOW and OverworldState and type(OverworldState.talkTo) == "function"
       and not OverworldState._vanillaPlusRoute8LassTalkTest20 then
      local nativeTalkTo = OverworldState.talkTo
      function OverworldState:talkTo(npc)
        if championReady()
           and npc and npc.def and npc.def.trainerClass
           and isRememberedTarget(self, npc)
           and type(self.trainerDefeated) == "function"
           and self:trainerDefeated(npc) then
          npc.frozen = true
          if npc.facePlayer and self.player then npc:facePlayer(self.player) end
          mod.log:info("v1.2.1-test31 Lass AFTER direct npc hook hit")
          gameRef.stack:push(TextBox.new(gameRef, vpFormatDialogue(lassAfterText()),
            function() npc.frozen = false end))
          return
        end
        return nativeTalkTo(self, npc)
      end
      OverworldState._vanillaPlusRoute8LassTalkTest20 = true
    end
  end


  -- Lt. Surge post-defeat trash-can Easter egg (test47) -------------------
  -- The lone empty can in Surge's upper room becomes a one-roll reward after
  -- every eligible Surge defeat. The 15-can switch puzzle downstairs remains
  -- completely vanilla.
  do
    local TextBox = require("src.render.TextBox")
    local VERMILION_GYM_TRASH = "VERMILION_GYM"
    local SURGE_TRASH_CLASS = "OPP_LT_SURGE"

    local function surgeTrashSave()
      return gameRef and gameRef.save
    end

    local function surgeStoryDefeated()
      local save=surgeTrashSave()
      local flags=save and save.flags or {}
      return flags.EVENT_BEAT_LT_SURGE and true or false
    end

    local function ensureSurgeTrashState()
      local save=surgeTrashSave()
      if not save then return end
      -- Existing saves that already beat story Surge receive exactly one
      -- initial claim. Fresh saves are armed by the actual battle win below.
      if save.vpSurgeTrashDefeatCount == nil then
        save.vpSurgeTrashDefeatCount = surgeStoryDefeated() and 1 or 0
      end
      if save.vpSurgeTrashClaimCount == nil then save.vpSurgeTrashClaimCount=0 end
    end

    local function armSurgeTrashReward()
      local save=surgeTrashSave()
      if not save then return end
      ensureSurgeTrashState()
      save.vpSurgeTrashDefeatCount=(tonumber(save.vpSurgeTrashDefeatCount) or 0)+1
      mod.log:info("v1.2.1-test47 Surge trash armed defeatCount="..tostring(save.vpSurgeTrashDefeatCount))
    end

    local function surgeTrashReady()
      local save=surgeTrashSave()
      if not save then return false end
      ensureSurgeTrashState()
      return (tonumber(save.vpSurgeTrashClaimCount) or 0) < (tonumber(save.vpSurgeTrashDefeatCount) or 0)
    end

    local function inSurgesUpperTrashSpot()
      local ow=gameRef and gameRef.overworld
      if not (ow and ow.map and ow.map.id==VERMILION_GYM_TRASH and ow.player) then return false end
      local fx,fy
      if type(ow.player.facingCell)=="function" then fx,fy=ow.player:facingCell() end
      fx=tonumber(fx); fy=tonumber(fy)
      -- Surge stands at (5,1) in the native map. His decorative empty trash can
      -- is the only trash interaction in this small upper room. Restricting the
      -- hook to this band prevents any of the downstairs switch cans from ever
      -- entering the reward system.
      return fx and fy and fy<=3 and fx>=2 and fx<=8
    end

    local function machineItemForMove(moveId)
      local items=gameRef and gameRef.data and gameRef.data.items or {}
      for id,def in pairs(items) do
        if type(def)=="table" and type(def.machine)=="table" and def.machine.move==moveId then return id end
      end
      return nil
    end

    local function addInventory(id,qty)
      local save=surgeTrashSave()
      if not (save and id) then return false end
      save.inventory=save.inventory or {}
      save.inventory[id]=math.min(99,(tonumber(save.inventory[id]) or 0)+(qty or 1))
      return true
    end

    local rewardTable={
      {weight=20,kind="item",id="RARE_CANDY",qty=1,label="RARE CANDY"},
      {weight=4, kind="item",id="RARE_CANDY",qty=5,label="5 RARE CANDIES"},
      {weight=3, kind="item",id="HP_UP",qty=1,label="HP UP"},
      {weight=3, kind="item",id="PROTEIN",qty=1,label="PROTEIN"},
      {weight=3, kind="item",id="IRON",qty=1,label="IRON"},
      {weight=3, kind="item",id="CARBOS",qty=1,label="CARBOS"},
      {weight=3, kind="item",id="CALCIUM",qty=1,label="CALCIUM"},
      {weight=6, kind="item",id="NUGGET",qty=1,label="NUGGET"},
      {weight=4, kind="item",id="MAX_ELIXER",qty=1,label="MAX ELIXIR"},
      {weight=4, kind="item",id="MAX_ETHER",qty=1,label="MAX ETHER"},
      {weight=4, kind="item",id="MAX_REVIVE",qty=1,label="MAX REVIVE"},
      {weight=4, kind="item",id="THUNDER_STONE",qty=1,label="THUNDER STONE"},
      {weight=4, kind="tm",move="THUNDERBOLT",label="TM24 THUNDERBOLT"},
      {weight=4, kind="tm",move="THUNDER",label="TM25 THUNDER"},
      {weight=4, kind="tm",move="THUNDER_WAVE",label="TM45 THUNDER WAVE"},
      {weight=4, kind="tm",move="HYPER_BEAM",label="TM15 HYPER BEAM"},
      {weight=4, kind="tm",move="EXPLOSION",label="TM47 EXPLOSION"},
      {weight=10,kind="coins",qty=3000,label="3000 COINS"},
    }

    local function rollSurgeTrashReward()
      local rng=(love and love.math and love.math.random) or math.random
      local roll=rng(100)
      local running=0
      for _,r in ipairs(rewardTable) do
        running=running+r.weight
        if roll<=running then return r,roll end
      end
      return rewardTable[1],roll
    end

    local function claimSurgeTrashReward()
      local save=surgeTrashSave()
      if not save or not surgeTrashReady() then return nil end
      local reward,roll=rollSurgeTrashReward()
      local label=reward.label
      if reward.kind=="coins" then
        save.coins=math.min(9999,(tonumber(save.coins) or 0)+(reward.qty or 0))
      elseif reward.kind=="tm" then
        local id=machineItemForMove(reward.move)
        if not id then
          -- Machine data should always resolve, but never burn a claim because
          -- of a runtime naming difference. Fall back to the common candy.
          reward={kind="item",id="RARE_CANDY",qty=1,label="RARE CANDY"}
          label=reward.label
          addInventory(reward.id,reward.qty)
        else
          addInventory(id,1)
        end
      else
        addInventory(reward.id,reward.qty or 1)
      end
      save.vpSurgeTrashClaimCount=tonumber(save.vpSurgeTrashDefeatCount) or 0
      mod.log:info("v1.2.1-test47 Surge trash claim roll="..tostring(roll).." reward="..tostring(label))

      local found="Hm? Something's buried in the trash!\f"
      if reward.kind=="coins" then
        local hasCase=(save.inventory and (save.inventory.COIN_CASE or 0)>0)
        if hasCase then return found.."Found 3000 COINS!\fThey were added to the COIN CASE." end
        return found.."Found 3000 COINS!"
      elseif reward.id=="RARE_CANDY" and (reward.qty or 1)==5 then
        return found.."Found 5 RARE CANDIES!"
      end
      return found.."Found "..tostring(label).."!"
    end

    -- Arm the original story defeat through the normal battle lifecycle.
    -- Vermilion battle handler and is armed there below to avoid double-counts.
    mod.events:on("battle.started",function(ev)
      local battle=ev and ev.battle
      if not battle or battle.kind~="trainer" or battle.oppClass~=SURGE_TRASH_CLASS then return end
      if battle._vpSurgeTrashWrapped then return end
      battle._vpSurgeTrashWrapped=true
      local nativeFinish=battle.onFinish
      battle.onFinish=function(result)
        if result=="win" then armSurgeTrashReward() end
        if nativeFinish then return nativeFinish(result) end
      end
    end)

    mod.events:on("game.ready",function() ensureSurgeTrashState() end)

    -- Let vanilla identify/render the trash-can interaction, then replace only
    -- its ordinary empty-can line in Surge's upper room when a reward is armed.
    if TextBox and type(TextBox.new)=="function" and not TextBox._vanillaPlusSurgeTrashTest47 then
      local nativeTrashTextBoxNew=TextBox.new
      TextBox.new=function(game,text,onDone,opts)
        if type(text)=="string" and surgeTrashReady() and inSurgesUpperTrashSpot() then
          local normalized=text:lower():gsub("[^a-z]+"," ")
          if normalized:find("only trash here",1,true) then
            local replacement=claimSurgeTrashReward()
            if replacement then
              text=vpFormatDialogue(replacement)
            end
          end
        end
        return nativeTrashTextBoxNew(game,text,onDone,opts)
      end
      TextBox._vanillaPlusSurgeTrashTest47=true
    end

  end

  -- Post-Champion TM mart expansion + Celadon PP UP (test48) -------------
  do
    local okShop,ShopMenu=pcall(require,"src.ui.ShopMenu")
    local okList,ListMenu=pcall(require,"src.ui.ListMenu")
    local Font=require("src.render.Font")
    -- Values are move IDs, resolved to the cartridge's actual TM item id at
    -- runtime. This keeps the table universal across Red/Blue/Yellow.
    local extraMovesByMap={
      PEWTER_MART={"FISSURE","DIG","ROCK_SLIDE"},
      CERULEAN_MART={"WATER_GUN","ICE_BEAM","BLIZZARD","REST"},
      VERMILION_MART={"THUNDER","SWIFT","THUNDER_WAVE"},
      LAVENDER_MART={"MEGA_DRAIN","PSYCHIC_M","TELEPORT","DREAM_EATER","PSYWAVE"},
      FUCHSIA_MART={"WHIRLWIND","RAGE","SELFDESTRUCT","EXPLOSION"},
      SAFFRON_MART={"TOXIC","COUNTER","SEISMIC_TOSS","MIMIC","BIDE","TRI_ATTACK"},
      CINNABAR_MART={"BUBBLEBEAM","METRONOME","SKULL_BASH"},
      VIRIDIAN_MART={"BODY_SLAM","DOUBLE_EDGE","EARTHQUAKE"},
      INDIGO_PLATEAU_LOBBY={"FIRE_BLAST","SKY_ATTACK"},
      CELADON_MART_2F={"SWORDS_DANCE","PAY_DAY","SOLARBEAM","THUNDERBOLT","SOFTBOILED"},
    }
    local function champion48(game)
      local flags=game and game.save and game.save.flags or {}
      return flags.EVENT_BEAT_CHAMPION_RIVAL and true or false
    end
    local function machineItem48(game,moveId)
      local items=game and game.data and game.data.items or {}
      for id,def in pairs(items) do
        if type(def)=="table" and type(def.machine)=="table" and def.machine.move==moveId then
          return id
        end
      end
      return nil
    end
    local function resolveMoves48(game,moves)
      local ids={}
      for _,move in ipairs(moves or {}) do
        local id=machineItem48(game,move)
        if id then ids[#ids+1]=id end
      end
      return ids
    end
    local function appendUnique48(stock,ids)
      local out,seen={},{}
      for _,id in ipairs(stock or {}) do out[#out+1]=id; seen[id]=true end
      for _,id in ipairs(ids or {}) do
        if not seen[id] then out[#out+1]=id; seen[id]=true end
      end
      return out
    end
    local function stockHasTM48(game,stock)
      for _,id in ipairs(stock or {}) do
        local def=game.data.items[id]
        if def and def.machine and tostring(id):sub(1,2)~="HM" then return true end
      end
      return false
    end
    local function stockHasVitamin48(stock)
      local hit=0
      local vitamin={HP_UP=true,PROTEIN=true,IRON=true,CARBOS=true,CALCIUM=true}
      for _,id in ipairs(stock or {}) do if vitamin[id] then hit=hit+1 end end
      return hit>=3
    end
    -- TM MARTS BUY/SELL layout (test54).
    -- Gen I only gives the stock list 160 horizontal pixels. Long full TM labels
    -- and 4-digit prices physically cannot coexist legibly on one row. Keep the
    -- complete TM## MOVE NAME in the list and place the selected TM's price in
    -- the existing footer/message box. Ordinary items retain normal inline prices.
    if false and okList and ListMenu and type(ListMenu.drawItemBox)=="function"
       and not ListMenu._vanillaPlusTMMartFooterTest54 then
      local nativeDrawItemBox=ListMenu.drawItemBox
      function ListMenu:drawItemBox()
        if not (mod.options:get("tm_marts") and self.dialogue and self.itemBox) then
          return nativeDrawItemBox(self)
        end
        local Theme=require("src.ui.Theme")
        local Strings=require("src.core.Strings")
        local TextBox=require("src.render.TextBox")
        love.graphics.setColor(1,1,1,1)
        Font.drawBox(0,2,20,11)
        love.graphics.setColor(0,0,0,1)
        if #self.items==0 then Font.draw(Strings("Nothing here."),24,32) end
        local shown,sawCancel=0,false
        local selectedTMPrice=nil
        for row=1,self.rows do
          local i=self.scroll+row; local item=self.items[i]; if not item then break end
          shown=shown+1; if item.cancel then sawCancel=true end
          local y=32+(row-1)*16
          local label=tostring(item.label or "")
          local rhs=item.sub or item.price or item.right
          local isTM=label:match("^TM%d%d%s") ~= nil
          Font.draw(label,16,y)
          if rhs and not isTM then Font.draw(rhs,152-Font.width(rhs),y) end
          if i==self.index then
            Font.drawCode(self.hollowIndex==i and Theme.cursorHollow or Theme.cursor,8,y)
            if isTM and rhs then selectedTMPrice=rhs end
          end
          if self.swapIndex==i and i~=self.index then Font.drawCode(Theme.cursorHollow,8,y) end
        end
        if shown==self.rows and not sawCancel then Font.drawCode(Theme.moreArrow,144,88) end
        if self.messageBox or self.footer or selectedTMPrice then
          Font.drawBox(0,12,20,6); love.graphics.setColor(0,0,0,1)
          local y=112
          if selectedTMPrice then
            Font.draw("PRICE "..tostring(selectedTMPrice),8,y)
            y=y+16
          end
          if self.footer then
            local flat={}
            for _,page in ipairs(TextBox.paginate(self.footer)) do for _,line in ipairs(page) do flat[#flat+1]=line end end
            local first=math.max(1,#flat-(selectedTMPrice and 0 or 1))
            for i=first,#flat do
              if y<=128 then Font.draw(flat[i],8,y); y=y+16 end
            end
          end
        end
        love.graphics.setColor(1,1,1,1)
      end
      ListMenu._vanillaPlusTMMartFooterTest54=true
    end

    if okShop and ShopMenu and type(ShopMenu.new)=="function" and not ShopMenu._vanillaPlusPostChampionTMTest48 then
      local native=ShopMenu.new
      function ShopMenu.new(game,stock,onQuit)
        if champion48(game) and mod.options:get("tm_marts") then
          local mapid=game.overworld and game.overworld.map and game.overworld.map.id
          if mapid=="INDIGO_PLATEAU_LOBBY" then
            -- Premium endgame mart: healing/recovery first, PP recovery next,
            -- field utility next, then the two Indigo TMs at the bottom.
            local items=game and game.data and game.data.items or {}
            if items.MAX_ETHER then items.MAX_ETHER.price=2500 end
            if items.MAX_ELIXER then items.MAX_ELIXER.price=5000 end
            local tmids=resolveMoves48(game,{"FIRE_BLAST","SKY_ATTACK"})
            stock={"MAX_POTION","FULL_RESTORE","MAX_REVIVE","MAX_ETHER","MAX_ELIXER","MAX_REPEL"}
            stock=appendUnique48(stock,tmids)
          else
            local moves=extraMovesByMap[mapid]
            if moves then
              if mapid~="CELADON_MART_2F" or stockHasTM48(game,stock) then
                stock=appendUnique48(stock,resolveMoves48(game,moves))
              end
            end
            if mapid=="CELADON_MART_5F" and stockHasVitamin48(stock) then
              local items=game and game.data and game.data.items or {}
              if items.PP_UP then items.PP_UP.price=9800 end
              stock=appendUnique48(stock,{"PP_UP"})
            end
          end
        end
        return native(game,stock,onQuit)
      end
      ShopMenu._vanillaPlusPostChampionTMTest48=true
    end
  end

  -- Selective visible-pickup modernization (test48) -----------------------
  do
    local TextBox=require("src.render.TextBox")
    local Bag=require("src.inventory.Bag")
    local okOW,OverworldState=pcall(require,"src.world.OverworldController")
    local pickup48={
      VIRIDIAN_FOREST={VIRIDIANFOREST_POKE_BALL={id="POKE_BALL",qty=5}},
      MT_MOON_1F={
        MTMOON1F_POTION1={id="POTION",qty=3},
        MTMOON1F_ESCAPE_ROPE={id="ESCAPE_ROPE",qty=2},
      },
      SS_ANNE_2F_ROOMS={
        SSANNE2FROOMS_MAX_ETHER={id="MAX_ETHER",qty=2},
      },
      ROCKET_HIDEOUT_B1F={
        ROCKETHIDEOUTB1F_ESCAPE_ROPE={id="REVIVE",qty=2},
        ROCKETHIDEOUTB1F_HYPER_POTION={id="HYPER_POTION",qty=2},
      },
      ROCKET_HIDEOUT_B2F={ROCKETHIDEOUTB2F_SUPER_POTION={id="NUGGET",qty=1}},
      WARDENS_HOUSE={WARDENSHOUSE_RARE_CANDY={id="RARE_CANDY",qty=2}},
      POKEMON_TOWER_3F={POKEMONTOWER3F_ESCAPE_ROPE={id="FULL_HEAL",qty=2}},
      POKEMON_TOWER_4F={
        POKEMONTOWER4F_ELIXER={id="ELIXER",qty=2},
        POKEMONTOWER4F_AWAKENING={id="AWAKENING",qty=3},
        POKEMONTOWER4F_HP_UP={id="HP_UP",qty=2},
      },
      POKEMON_TOWER_5F={POKEMONTOWER5F_NUGGET={id="NUGGET",qty=2}},
      POKEMON_TOWER_6F={POKEMONTOWER6F_RARE_CANDY={id="RARE_CANDY",qty=2}},
      SILPH_CO_3F={SILPHCO3F_HYPER_POTION={id="HYPER_POTION",qty=3}},
      SILPH_CO_4F={
        SILPHCO4F_FULL_HEAL={id="FULL_HEAL",qty=3},
        SILPHCO4F_MAX_REVIVE={id="MAX_REVIVE",qty=2},
      },
      SILPH_CO_6F={SILPHCO6F_HP_UP={id="HP_UP",qty=2}},
      SAFARI_ZONE_EAST={
        SAFARIZONEEAST_FULL_RESTORE={id="FULL_RESTORE",qty=2},
      },
      SAFARI_ZONE_WEST={SAFARIZONEWEST_MAX_POTION={id="MAX_POTION",qty=2}},
      POKEMON_MANSION_1F={POKEMONMANSION1F_ESCAPE_ROPE={id="HYPER_POTION",qty=2}},
      POKEMON_MANSION_3F={POKEMONMANSION3F_MAX_POTION={id="MAX_POTION",qty=2}},
      POKEMON_MANSION_B1F={POKEMONMANSIONB1F_FULL_RESTORE={id="FULL_RESTORE",qty=2}},
      POWER_PLANT={
        POWERPLANT_CARBOS={id="CARBOS",qty=2},
        POWERPLANT_RARE_CANDY={id="RARE_CANDY",qty=2},
      },
      VICTORY_ROAD_1F={VICTORYROAD1F_RARE_CANDY={id="RARE_CANDY",qty=3}},
      VICTORY_ROAD_2F={VICTORYROAD2F_FULL_HEAL={id="FULL_RESTORE",qty=2}},
      VICTORY_ROAD_3F={VICTORYROAD3F_MAX_REVIVE={id="MAX_REVIVE",qty=2}},
    }
    -- TEST51 QA ONLY: visibly respawn five representative pickups on map entry.
    -- Clearing save.itemsTaken before/after CONTINUE proved timing-sensitive, so
    -- this QA path reconstructs the original map object after the map is loaded.
    -- Each representative object is re-added only until the player collects it
    -- once in test51; normal bundle collection then removes it as usual.
    local rearm51={
      VIRIDIAN_FOREST="VIRIDIANFOREST_POKE_BALL",
      MT_MOON_1F="MTMOON1F_ESCAPE_ROPE",
      ROCKET_HIDEOUT_B1F="ROCKETHIDEOUTB1F_ESCAPE_ROPE",
      POWER_PLANT="POWERPLANT_RARE_CANDY",
      VICTORY_ROAD_1F="VICTORYROAD1F_RARE_CANDY",
    }
    local okNPC51,NPC51=pcall(require,"src.world.NPC")
    local function qaKey51(mapid) return "vpPickupQACollectedTest51_"..tostring(mapid) end
    local function respawnRepresentativePickup51(ev)
      local mapid=ev and ev.mapId
      local wanted=mapid and rearm51[mapid]
      local save=gameRef and gameRef.save
      if not wanted or not save or save[qaKey51(mapid)] or not (okNPC51 and NPC51) then return end
      local ow=gameRef and gameRef.stack and gameRef.stack:top()
      if not (ow and ow.map and ow.map.id==mapid) then return end
      -- Avoid duplicates if the original ball was never collected on this save.
      for _,n in ipairs(ow.npcs or {}) do
        if n and n.def and n.def.name==wanted then return end
      end
      local def=nil
      local sourceObjects=(ow.map.def and ow.map.def.objects)
        or (gameRef.data and gameRef.data.maps and gameRef.data.maps[mapid] and gameRef.data.maps[mapid].objects)
        or {}
      for _,obj in ipairs(sourceObjects) do
        if obj.name==wanted then def=obj; break end
      end
      if not def then
        mod.log:warn("v1.2.1-test51 QA pickup definition not found "..tostring(mapid).." / "..tostring(wanted))
        return
      end
      local copy={}
      for k,v in pairs(def) do copy[k]=v end
      -- Use a QA-only index so the constructor cannot inherit the original
      -- object's already-taken save id. The bundle hook still keys by def.name.
      copy.index=240
      local npc=NPC51.new(gameRef.data,mapid,copy)
      npc.vpQARearmed51=true
      npc.vpQAOriginalName51=wanted
      table.insert(ow.npcs,npc); table.insert(ow.entities,npc)
      mod.log:info("v1.2.1-test51 visibly re-armed QA pickup "..tostring(mapid).." / "..tostring(wanted))
    end
    mod.events:on("map.entered",respawnRepresentativePickup51)

    local function pickupRule48(self,npc)
      if not (self and self.map and npc and npc.def) then return nil end
      local byMap=pickup48[self.map.id]
      if not byMap then return nil end
      return byMap[npc.def.name]
    end
    local function removePickupNpc48(self,npc)
      local save=gameRef and gameRef.save
      save.itemsTaken=save.itemsTaken or {}
      save.itemsTaken[npc.id]=true
      if npc.vpQARearmed51 and self.map and self.map.id then
        save["vpPickupQACollectedTest51_"..tostring(self.map.id)]=true
      end
      for i,n in ipairs(self.npcs or {}) do if n==npc then table.remove(self.npcs,i) break end end
      for i,e in ipairs(self.entities or {}) do if e==npc then table.remove(self.entities,i) break end end
    end
    if okOW and OverworldState and type(OverworldState.talkTo)=="function"
       and not OverworldState._vanillaPlusPickupBundlesTest48 then
      local native=OverworldState.talkTo
      function OverworldState:talkTo(npc)
        local rule=pickupRule48(self,npc)
        if rule and npc.def.item and npc.def.item~="0" and npc.def.item~=0 then
          npc.frozen=true
          local save=gameRef.save
          if not Bag.add(save,rule.id,rule.qty or 1,gameRef.data) then
            gameRef.stack:push(TextBox.new(gameRef,vpFormatDialogue("No more room for items!"),
              function() npc.frozen=false end))
            return
          end
          removePickupNpc48(self,npc)
          local def=gameRef.data.items[rule.id]
          local name=def and def.name or rule.id
          local qty=rule.qty or 1
          local count=(qty>1) and ("x"..tostring(qty).." ") or ""
          -- One textbox/page. The old form-feed produced PLAYER found, an
          -- empty-looking beat, then the quantity on a second page.
          local message=tostring(save.player and save.player.name or "PLAYER").." found\n"..count..tostring(name).."!"
          gameRef.stack:push(TextBox.new(gameRef,vpFormatDialogue(message),nil,
            TextBox.soundOpts(gameRef,(def and def.keyItem) and "Get_Key_Item" or "Get_Item1")))
          return
        end
        return native(self,npc)
      end
      OverworldState._vanillaPlusPickupBundlesTest48=true
    end
  end

  -- Post-Champion Trainer AI diagnostic (test31) ---------------------------
  -- Test24 proved substantially better move selection and Test25 proved the
  -- six-Pokemon finite-bag / battle-state layer. Test31 retains team management:
  -- matchup-aware replacement after a KO plus conservative voluntary tactical
  -- switching. Other trainer battles keep the proven smarter move scorer; wild
  -- battles remain untouched.
  do
    local okAI, TrainerAI = pcall(require, "src.battle.TrainerAI")
    local okChart, TypeChart = pcall(require, "src.battle.TypeChart")
    local okTurn, TurnOrder = pcall(require, "src.battle.TurnOrder")
    local okBattleState, BattleState = pcall(require, "src.battle.BattleState")

    local function championAIReady(battle)
      local g = battle and battle.game
      local save = g and g.save or (gameRef and gameRef.save)
      local flags = save and save.flags or {}
      return battle and battle.kind == "trainer"
        and flags.EVENT_BEAT_CHAMPION_RIVAL
    end

    local function isLassTestBattle(battle)
      return battle and battle._vpRoute8LassNpcId ~= nil
        and type(battle._vpLassInventory) == "table"
    end

    local function typeMultiplier(moveType, targetTypes)
      if not (okChart and TypeChart and TypeChart.rows and moveType) then return 1 end
      local rows = TypeChart.rows(moveType, targetTypes or {}) or {}
      if #rows == 0 then return 1 end
      local mult = 1
      for _, value in ipairs(rows) do
        mult = mult * ((tonumber(value) or 10) / 10)
      end
      return mult
    end

    local function effectiveSpeed(battler)
      if okTurn and TurnOrder and TurnOrder.effectiveSpeed then
        return TurnOrder.effectiveSpeed(battler)
      end
      return battler and battler.curStats and battler.curStats.speed or 0
    end

    local STATUS_MOVE_SCORE = {
      SING = 95,
      SLEEP_POWDER = 100,
      HYPNOSIS = 95,
      LOVELY_KISS = 105,
      SPORE = 120,
      THUNDER_WAVE = 90,
      STUN_SPORE = 82,
      GLARE = 88,
      TOXIC = 84,
      POISONPOWDER = 72,
      CONFUSE_RAY = 76,
      SUPERSONIC = 60,
      LEECH_SEED = 78,
    }

    local HEAL_MOVE_SCORE = {
      SOFTBOILED = 145,
      RECOVER = 145,
      REST = 130,
    }

    local SETUP_MOVE_SCORE = {
      SWORDS_DANCE = 78,
      AMNESIA = 82,
      AGILITY = 68,
      GROWTH = 65,
      HARDEN = 42,
      WITHDRAW = 42,
      DEFENSE_CURL = 42,
      LIGHT_SCREEN = 60,
      REFLECT = 60,
      MINIMIZE = 58,
      DOUBLE_TEAM = 58,
    }

    local FIXED_DAMAGE = {
      SEISMIC_TOSS = true,
      NIGHT_SHADE = true,
      DRAGON_RAGE = true,
      SONICBOOM = true,
      SUPER_FANG = true,
    }

    local OHKO_MOVE = { FISSURE = true, HORN_DRILL = true, GUILLOTINE = true }

    local function moveUsable(battle, index, move)
      if not move then return false end
      local enemy = battle.enemy
      if enemy and enemy.disabledSlot == index then return false end
      local unlimited = battle.ruleset and battle.ruleset.enemyUnlimitedPP
      return unlimited or (move.pp or 0) > 0
    end

    local function ohkoViable(battle, move)
      if not (battle and move and OHKO_MOVE[move.id]) then return false end
      local def = battle.data and battle.data.moves and battle.data.moves[move.id]
      if not def then return false end
      local enemy, target = battle.enemy, battle.player
      if not enemy or not target then return false end
      -- Gen I OHKO moves automatically fail when the user is slower.
      if effectiveSpeed(enemy) < effectiveSpeed(target) then return false end
      -- They still respect type immunity (Fissure vs Flying, Horn Drill vs Ghost).
      if typeMultiplier(def.type, target.curTypes or {}) <= 0 then return false end
      return true
    end

    local function scoreMove(battle, move)
      local def = battle.data and battle.data.moves and battle.data.moves[move.id]
      if not def then return -1000 end

      local enemy = battle.enemy
      local target = battle.player
      local hp = enemy and enemy.mon and enemy.mon.hp or 1
      local maxHP = enemy and enemy.mon and enemy.mon.stats and enemy.mon.stats.hp or hp
      local hpRatio = maxHP > 0 and hp / maxHP or 1

      -- OHKO judgment is explicit in test27. X Accuracy makes a viable OHKO
      -- enormously attractive, but no amount of accuracy can defeat the Gen I
      -- speed gate or a type immunity. This is especially important for
      -- Snorlax: Fissure is present partly to prove the AI can refuse it.
      if OHKO_MOVE[move.id] then
        if not ohkoViable(battle, move) then return -600 end
        if enemy and enemy.xAccuracy then return 235 end
        return 58
      end

      -- Strong healing logic: recover when actually hurt, strongly avoid
      -- wasting healing at high HP. Rest also cures status, so status raises
      -- its value, while sleeping already makes choosing Rest pointless.
      if HEAL_MOVE_SCORE[move.id] then
        if move.id == "REST" and enemy and enemy.mon and enemy.mon.status == "SLP" then
          return -100
        end
        local bonus = (enemy and enemy.mon and enemy.mon.status) and 18 or 0
        if hpRatio <= 0.25 then return HEAL_MOVE_SCORE[move.id] + 55 + bonus end
        if hpRatio <= 0.45 then return HEAL_MOVE_SCORE[move.id] + 25 + bonus end
        if hpRatio <= 0.65 then return HEAL_MOVE_SCORE[move.id] - 20 + bonus end
        return 5 + bonus
      end

      -- Do not repeatedly throw major status at an already-statused target.
      if STATUS_MOVE_SCORE[move.id] then
        if target and target.mon and target.mon.status then return 8 end
        return STATUS_MOVE_SCORE[move.id]
      end

      -- Setup has value only while the board permits it. AMNESIA gets an
      -- additional diagnostic heuristic: Snorlax values it much more against
      -- a target whose Special exceeds its Attack, and stops stacking once its
      -- Special stage is already high. This tests situational setup rather
      -- than "click Amnesia because Amnesia exists."
      if SETUP_MOVE_SCORE[move.id] then
        local stageName = move.id == "AMNESIA" and "special" or nil
        local stage = stageName and ((enemy.stages and enemy.stages[stageName]) or 0) or 0
        if stage >= 4 then return 8 end
        if hpRatio < 0.45 then return 12 end

        local base = SETUP_MOVE_SCORE[move.id]
        if move.id == "AMNESIA" and target and target.mon and target.mon.stats then
          local ts = target.mon.stats
          if (ts.special or 0) > (ts.attack or 0) then base = base + 30
          elseif (ts.attack or 0) > (ts.special or 0) * 1.20 then base = base - 28 end
        end
        if stage >= 2 then base = base - 30 end
        local turn = battle.turnCount or 0
        if turn <= 2 and hpRatio > 0.65 then return base + 15 end
        if hpRatio > 0.70 then return base end
        return math.max(20, base - 25)
      end

      if FIXED_DAMAGE[move.id] then
        if move.id == "SUPER_FANG" then
          local thp = target and target.mon and target.mon.hp or 1
          return thp > 1 and 105 or 10
        end
        return 105
      end

      local power = tonumber(def.power) or 0
      if power <= 0 then return 30 end

      local mult = typeMultiplier(def.type, target and target.curTypes or {})
      if mult <= 0 then return -500 end

      local score = power * mult

      -- STAB.
      for _, t in ipairs((enemy and enemy.curTypes) or {}) do
        if t == def.type then score = score * 1.5 break end
      end

      -- Accuracy-aware preference.
      local acc = tonumber(def.accuracy)
      if acc and acc > 0 then
        if acc > 100 then score = score * math.min(1, acc / 255)
        else score = score * math.min(1, acc / 100) end
      end

      -- Prefer finishing a weakened target instead of getting cute with setup.
      local targetHP = target and target.mon and target.mon.hp or 9999
      if targetHP <= math.max(1, power) then score = score + 25 end

      return score
    end

    local function bestMove(battle)
      local usable = {}
      for i, move in ipairs((battle.enemy and battle.enemy.curMoves) or {}) do
        if moveUsable(battle, i, move) then
          usable[#usable + 1] = { move = move, score = scoreMove(battle, move) }
        end
      end
      if #usable == 0 then return nil end

      local best = -math.huge
      for _, row in ipairs(usable) do if row.score > best then best = row.score end end
      local finalists = {}
      local threshold = best - math.max(2, math.abs(best) * 0.05)
      for _, row in ipairs(usable) do
        if row.score >= threshold then finalists[#finalists + 1] = row.move end
      end
      local chosen = finalists[1]
      if #finalists > 1 and battle.rng then chosen = finalists[battle.rng(1, #finalists)] end
      return chosen, best
    end

    -- Track only moves the player has actually attempted in this battle.
    -- Switching logic may use those revealed moves, but never peeks at the
    -- player's full moveset or the action selected for the current turn.
    mod.events:on("battle.turn_started", function(ev)
      local battle = ev and ev.battle
      if not isLassTestBattle(battle) then return end
      local action = ev.playerAction
      local id = action and action.id
      local mon = battle.player and battle.player.mon
      if id and mon then
        battle._vpSeenPlayerMoves = battle._vpSeenPlayerMoves or {}
        local seen = battle._vpSeenPlayerMoves[mon] or {}
        seen[id] = true
        battle._vpSeenPlayerMoves[mon] = seen
      end
    end)

    -- Score a party Pokemon as a switch-in against the player's *current*
    -- active Pokemon. This intentionally uses only visible/current battle state:
    -- species/types, actually revealed moves, HP/status and matchup. It never
    -- reads the player's selected action for the turn.
    local function rawEffectiveSpeed(mon)
      local speed = mon and mon.stats and mon.stats.speed or 0
      if mon and mon.status == "PAR" then speed = math.max(1, math.floor(speed / 4)) end
      return speed
    end

    local function candidateSwitchScore(battle, mon, index)
      if not battle or not mon or (mon.hp or 0) <= 0 then return -math.huge end
      local pdef = battle.data and battle.data.pokemon and battle.data.pokemon[mon.species]
      if not pdef then return -math.huge end
      local target = battle.player
      if not target then return -math.huge end
      local targetTypes = target.curTypes or {}
      local ownTypes = pdef.types or {}
      local maxHP = mon.stats and mon.stats.hp or math.max(1, mon.hp or 1)
      local hpRatio = math.max(0, math.min(1, (mon.hp or 0) / math.max(1, maxHP)))

      local score = 18 + hpRatio * 28
      if mon.status then score = score - 10 end

      -- Offensive ceiling into the current opponent. STAB and super-effective
      -- coverage matter; fixed-damage moves retain useful but not absurd value.
      local bestOffense = 0
      for _, move in ipairs(mon.moves or {}) do
        local mdef = battle.data and battle.data.moves and battle.data.moves[move.id]
        if mdef then
          local power = tonumber(mdef.power) or 0
          local mult = typeMultiplier(mdef.type, targetTypes)
          local value = 0
          if OHKO_MOVE[move.id] then
            local speedOK = rawEffectiveSpeed(mon) >= effectiveSpeed(target)
            if speedOK and mult > 0 then value = 90 else value = 0 end
          elseif FIXED_DAMAGE[move.id] then
            value = 48 * mult
          elseif power > 0 and mult > 0 then
            value = power * mult
            for _, t in ipairs(ownTypes) do
              if t == mdef.type then value = value * 1.18 break end
            end
          elseif STATUS_MOVE_SCORE[move.id] and not (target.mon and target.mon.status) then
            value = STATUS_MOVE_SCORE[move.id] * 0.45
          end
          if value > bestOffense then bestOffense = value end
        end
      end
      score = score + math.min(95, bestOffense * 0.42)

      -- Defensive matchup against moves the player currently has on screen.
      -- We do not predict which one the player chose this turn. A candidate
      -- that is immune/resistant to several known attacks gets rewarded;
      -- something weak to the player's strongest coverage gets penalized.
      local worstThreat, resistCredit = 0, 0
      local seen = battle._vpSeenPlayerMoves and target.mon
        and battle._vpSeenPlayerMoves[target.mon] or {}
      for moveId in pairs(seen or {}) do
        local mdef = battle.data and battle.data.moves and battle.data.moves[moveId]
        if mdef and (tonumber(mdef.power) or 0) > 0 then
          local mult = typeMultiplier(mdef.type, ownTypes)
          local threat = (tonumber(mdef.power) or 0) * mult
          if threat > worstThreat then worstThreat = threat end
          if mult == 0 then resistCredit = resistCredit + 20
          elseif mult < 1 then resistCredit = resistCredit + 7 end
        end
      end
      score = score + math.min(28, resistCredit) - math.min(70, worstThreat * 0.22)

      -- Preserve premium healthy pieces slightly, but do not hard-code an
      -- order. These are tie-shapers, not commands.
      local role = {
        NIDOKING = 7, NIDOQUEEN = 6, SNORLAX = 5,
        CHANSEY = 4, CLEFABLE = 3, WIGGLYTUFF = 2,
      }
      score = score + (role[mon.species] or 0)
      return score
    end

    local function bestSwitchCandidate(battle)
      local bestIndex, bestScore = nil, -math.huge
      for i, mon in ipairs(battle.enemyParty or {}) do
        if i ~= battle.enemyIndex and (mon.hp or 0) > 0 then
          local score = candidateSwitchScore(battle, mon, i)
          if score > bestScore then bestIndex, bestScore = i, score end
        end
      end
      return bestIndex, bestScore
    end

    local function activeSwitchScore(battle)
      if not battle or not battle.enemy or not battle.enemy.mon then return -math.huge end
      return candidateSwitchScore(battle, battle.enemy.mon, battle.enemyIndex)
    end

    local function voluntarySwitchAction(battle)
      if not isLassTestBattle(battle) then return nil end
      local enemy = battle.enemy
      if not enemy or not enemy.mon or (enemy.mon.hp or 0) <= 0 then return nil end

      -- Do not throw away a meaningful setup state just because another mon is
      -- marginally prettier on paper.
      local stages = enemy.stages or {}
      local setup = math.max(stages.attack or 0, stages.defense or 0,
        stages.speed or 0, stages.special or 0, stages.accuracy or 0,
        stages.evasion or 0)
      if setup >= 2 or enemy.xAccuracy then return nil end

      local turn = battle.turnCount or 0
      if battle._vpLastVoluntarySwitchTurn
         and turn - battle._vpLastVoluntarySwitchTurn < 2 then return nil end

      local idx, candidate = bestSwitchCandidate(battle)
      if not idx then return nil end
      local active = activeSwitchScore(battle)
      local hp = enemy.mon.hp or 0
      local maxHP = enemy.mon.stats and enemy.mon.stats.hp or math.max(1, hp)
      local hpRatio = hp / math.max(1, maxHP)

      -- Test27 restraint: voluntary switches require a clearly superior matchup,
      -- and the two-turn cooldown prevents ping-pong. Only a critically wounded
      -- active mon gets the somewhat smaller escape threshold.
      local margin = hpRatio < 0.30 and 30 or 50
      if candidate < active + margin then return nil end

      battle._vpLastVoluntarySwitchTurn = turn
      mod.log:info("v1.2.1-test27 Lass AI chose SWITCH "
        .. tostring(battle.enemyIndex) .. "->" .. tostring(idx)
        .. " active=" .. tostring(active) .. " candidate=" .. tostring(candidate))
      return { special = "aiSwitch", index = idx }
    end

    -- Native Gen1Recomp replaces a fainted enemy by scanning party slots for
    -- the first healthy mon. For this one diagnostic battle, temporarily mask
    -- the other healthy slots during that synchronous scan so the engine picks
    -- our matchup-aware choice. HP is restored immediately afterward; the
    -- engine keeps the chosen enemyIndex and owns all normal send-out/UI flow.
    if okBattleState and BattleState and type(BattleState.enemyMonFainted) == "function"
       and not BattleState._vanillaPlusTest27Replacement then
      local nativeEnemyMonFainted = BattleState.enemyMonFainted
      BattleState.enemyMonFainted = function(battle, ...)
        if isLassTestBattle(battle) then
          local idx, score = bestSwitchCandidate(battle)
          if idx then
            local masked = {}
            for i, mon in ipairs(battle.enemyParty or {}) do
              if i ~= idx and (mon.hp or 0) > 0 then
                masked[i] = mon.hp
                mon.hp = 0
              end
            end
            mod.log:info("v1.2.1-test27 Lass replacement chose slot="
              .. tostring(idx) .. " score=" .. tostring(score))
            local out = nativeEnemyMonFainted(battle, ...)
            for i, hp in pairs(masked) do
              if battle.enemyParty[i] then battle.enemyParty[i].hp = hp end
            end
            return out
          end
        end
        return nativeEnemyMonFainted(battle, ...)
      end
      BattleState._vanillaPlusTest27Replacement = true
    end

    local function bagCount(battle, id)
      local bag = battle and battle._vpLassInventory
      return (bag and tonumber(bag[id])) or 0
    end

    local function spendBag(battle, id)
      local bag = battle and battle._vpLassInventory
      if not bag or (bag[id] or 0) <= 0 then return false end
      bag[id] = bag[id] - 1
      mod.log:info("v1.2.1-test27 Lass spent " .. id .. "; left=" .. tostring(bag[id]))
      return true
    end

    local REVIVE_VALUE = {
      NIDOKING = 55, NIDOQUEEN = 52, CHANSEY = 50,
      SNORLAX = 48, CLEFABLE = 44, WIGGLYTUFF = 40,
    }

    local function reviveCandidate(battle)
      local bestIndex, bestScore = nil, -math.huge
      local targetTypes = battle.player and battle.player.curTypes or {}
      for i, mon in ipairs(battle.enemyParty or {}) do
        if (mon.hp or 0) <= 0 then
          local score = REVIVE_VALUE[mon.species] or 30
          -- Reward a fainted teammate that owns useful coverage into the
          -- currently active player Pokemon. This is matchup-aware targeting,
          -- not simply "revive the first dead slot."
          for _, move in ipairs(mon.moves or {}) do
            local def = battle.data and battle.data.moves and battle.data.moves[move.id]
            if def and (tonumber(def.power) or 0) > 0 then
              local mult = typeMultiplier(def.type, targetTypes)
              if mult > 1 then score = score + 18 * mult end
            end
          end
          if score > bestScore then bestIndex, bestScore = i, score end
        end
      end
      return bestIndex, bestScore
    end

    local function lassItemAction(battle)
      local enemy = battle.enemy
      if not enemy or not enemy.mon then return nil end
      local hp, maxHP = enemy.mon.hp or 0, enemy.mon.stats and enemy.mon.stats.hp or 1
      local hpRatio = maxHP > 0 and hp / maxHP or 1
      local status = enemy.mon.status

      -- Save a critically threatened active Pokemon before spending a turn
      -- resurrecting somebody else.
      if bagCount(battle, "FULL_RESTORE") > 0
         and (hpRatio <= 0.27 or (status and hpRatio <= 0.48)) then
        if spendBag(battle, "FULL_RESTORE") then
          return { special = "aiItem", item = "FULL_RESTORE" }
        end
      end

      -- Full Heal is for meaningful status when HP does not justify burning a
      -- much more valuable Full Restore.
      if status and bagCount(battle, "FULL_HEAL") > 0 and hpRatio > 0.40 then
        if spendBag(battle, "FULL_HEAL") then
          return { special = "aiItem", item = "FULL_HEAL" }
        end
      end

      -- X Accuracy is deliberately tied to a *currently viable* OHKO line.
      -- Snorlax must not use it merely because it knows Fissure when the speed
      -- gate makes Fissure fail.
      if bagCount(battle, "X_ACCURACY") > 0 and not enemy.xAccuracy and hpRatio > 0.38 then
        for _, move in ipairs(enemy.curMoves or {}) do
          if OHKO_MOVE[move.id] and ohkoViable(battle, move) then
            if spendBag(battle, "X_ACCURACY") then
              return { special = "aiItem", item = "X_ACCURACY" }
            end
          end
        end
      end

      -- The single X Attack is reserved for a healthy physical attacker that
      -- can actually cash in on it. In this test roster that chiefly means
      -- Snorlax or Wigglytuff, not Chansey wasting everybody's time.
      local species = enemy.mon.species
      local atkStage = (enemy.stages and enemy.stages.attack) or 0
      if bagCount(battle, "X_ATTACK") > 0 and atkStage <= 0 and hpRatio > 0.68
         and (species == "SNORLAX" or species == "WIGGLYTUFF") then
        if spendBag(battle, "X_ATTACK") then
          return { special = "aiItem", item = "X_ATTACK" }
        end
      end

      -- Reviving costs a whole turn, so do it only from a reasonably safe
      -- active position. Pick the best fainted teammate by strategic value and
      -- current matchup. Max Revive is conserved for a premium target or when
      -- the roster is getting thin; otherwise spend a normal Revive first.
      if hpRatio > 0.58 and (bagCount(battle, "REVIVE") > 0 or bagCount(battle, "MAX_REVIVE") > 0) then
        local idx, value = reviveCandidate(battle)
        if idx then
          local alive = 0
          for _, mon in ipairs(battle.enemyParty or {}) do if (mon.hp or 0) > 0 then alive = alive + 1 end end
          local item
          if bagCount(battle, "MAX_REVIVE") > 0 and ((value or 0) >= 70 or alive <= 2) then
            item = "MAX_REVIVE"
          elseif bagCount(battle, "REVIVE") > 0 then
            item = "REVIVE"
          elseif bagCount(battle, "MAX_REVIVE") > 0 then
            item = "MAX_REVIVE"
          end
          if item and spendBag(battle, item) then
            battle._vpAIReviveIndex = idx
            return { special = "aiItem", item = item }
          end
        end
      end

      return nil
    end

    -- Gen1Recomp's vanilla trainer-item helper handles Full Restore, Full Heal
    -- and X Attack, but vanilla trainers never carry X Accuracy or Revives.
    -- Extend that helper only for our diagnostic actions so the normal battle
    -- queue still owns item turns and animations.
    if okAI and TrainerAI and type(TrainerAI.useItem) == "function"
       and not TrainerAI._vanillaPlusTest27Items then
      local nativeUseItem = TrainerAI.useItem
      TrainerAI.useItem = function(battle, item)
        if isLassTestBattle(battle) and item == "X_ACCURACY" then
          battle.enemy.xAccuracy = true
          local trainerName = battle.trainer and battle.trainer.name or "TRAINER"
          return { trainerName .. "\nused X ACCURACY!" }
        end
        if isLassTestBattle(battle) and (item == "REVIVE" or item == "MAX_REVIVE") then
          local idx = battle._vpAIReviveIndex
          battle._vpAIReviveIndex = nil
          local mon = idx and battle.enemyParty and battle.enemyParty[idx]
          if mon and (mon.hp or 0) <= 0 then
            local maxHP = mon.stats and mon.stats.hp or 1
            mon.hp = item == "MAX_REVIVE" and maxHP or math.max(1, math.floor(maxHP / 2))
            local trainerName = battle.trainer and battle.trainer.name or "TRAINER"
            local pdef = battle.data and battle.data.pokemon and battle.data.pokemon[mon.species]
            local monName = mon.nickname or (pdef and pdef.name) or mon.species
            return {
              trainerName .. "\nused " .. (item == "MAX_REVIVE" and "MAX REVIVE" or "REVIVE") .. "!",
              monName .. " was\nrevived!",
            }
          end
          return {}
        end
        return nativeUseItem(battle, item)
      end
      TrainerAI._vanillaPlusTest27Items = true
    end

    if okAI and TrainerAI and mod.hooks then
      mod.hooks:wrap("battle.enemy_action", function(next, battle)
        if not championAIReady(battle) then return next(battle) end

        -- For the Lass stress test we replace her vanilla class-action roll
        -- with our finite bag reasoning. Forced/locked moves always win first.
        if isLassTestBattle(battle) then
          local locked = battle.lockedAction and battle:lockedAction(battle.enemy)
          if locked then return locked end

          local itemAction = lassItemAction(battle)
          if itemAction then
            mod.log:info("v1.2.1-test27 Lass AI chose ITEM " .. tostring(itemAction.item))
            return itemAction
          end

          local switchAction = voluntarySwitchAction(battle)
          if switchAction then return switchAction end

          local chosen, score = bestMove(battle)
          if chosen then
            mod.log:info("v1.2.1-test27 Lass AI chose MOVE "
              .. tostring(chosen.id) .. " score=" .. tostring(score))
            return chosen
          end
          return next(battle)
        end

        -- Other post-Champion trainers retain test24 behavior: let vanilla
        -- resolve any class item/switch/forced action, then improve move choice.
        local vanilla = next(battle)
        if vanilla and vanilla.special then return vanilla end
        if vanilla and vanilla.struggle then return vanilla end
        local locked = battle.lockedAction and battle:lockedAction(battle.enemy)
        if locked then return vanilla end

        local chosen, score = bestMove(battle)
        if chosen then
          mod.log:info("v1.2.1-test27 Champion AI chose "
            .. tostring(chosen.id) .. " score=" .. tostring(score))
          return chosen
        end
        return vanilla
      end, 50)
    end
  end

  -- TELEPORT anywhere: add TELEPORT to the party submenu indoors instead of
  -- changing the move itself. Selection reuses the engine's native escape
  -- action and animation, so destination/save semantics remain vanilla.
  mod.hooks:wrap("ui.party.submenu", function(next, game, items, mon, ctx)
    local out = next(game, items, mon, ctx)
    if not mod.options:get("indoor_teleport") or not ctx or ctx.battle or not ctx.overworld then
      return out
    end
    local hasTeleport = false
    for _, mv in ipairs(mon.moves or {}) do if mv.id == "TELEPORT" then hasTeleport = true break end end
    if not hasTeleport then return out end
    for _, item in ipairs(out or {}) do if item.action == "escape" or item.label == "TELEPORT" then return out end end
    -- Field moves sit above STATS/SWITCH/CANCEL in the native menu.
    local insertAt = math.max(1, #(out or {}) - 1)
    table.insert(out, insertAt, { label = "TELEPORT", action = "escape" })
    return out
  end)

  -- Bill's post-Champion Tradeback machine + discovery flow.
  -- Unlocks after the player becomes Champion and completes Bill's story.
  do
    local ok, OverworldState = pcall(require, "src.world.OverworldController")
    if ok and OverworldState and not OverworldState._vanillaPlusBillWrapped then
      OverworldState._vanillaPlusBillWrapped = true
      local originalBillsHousePC = OverworldState.billsHousePC
      local originalOpenPC = OverworldState.openPC
      local originalTalkTo = OverworldState.talkTo

      local function tradebackUnlocked(game)
        local flags = game and game.save and game.save.flags or {}
        return mod.options:get("bill_trade_machine")
          and flags.EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
          and flags.EVENT_BEAT_CHAMPION_RIVAL
      end

      -- One-time breadcrumb on the NEXT Pokemon Center-style PC access.
      -- It intentionally does not explain trade evolutions; it only gives
      -- the player an organic reason to revisit Bill.
      function OverworldState:openPC(onDone)
        local game = gameRef
        if tradebackUnlocked(game)
          and not mod.save:get("tradeback_pc_message_seen_v1") then
          mod.save:set("tradeback_pc_message_seen_v1", true)
          local TextBox = require("src.render.TextBox")
          game.stack:push(TextBox.new(game,
            "INCOMING MESSAGE!",
            function()
              game.stack:push(TextBox.new(game,
                vpFormatDialogue("BILL: Hey! I've been working on a new machine. I think you'll want to see this one. Come by my cottage when you get a chance!"),
                function()
                  originalOpenPC(self, onDone)
                end))
            end))
          return
        end
        return originalOpenPC(self, onDone)
      end

      -- Bill gives the feature's one-time, non-spoilery introduction when
      -- the player comes back after receiving the PC message.
      function OverworldState:talkTo(npc)
        local game = gameRef
        -- After Bill's original story is complete he is the only talkable NPC
        -- in BILLS_HOUSE, so map + unlock state is more reliable than depending
        -- on an engine-specific NPC definition name.
        local isBill = self.map and self.map.id == "BILLS_HOUSE" and npc

        local billLines = {
          "BILL: POKEMON storage\nhas come a long way.\fI still remember when\nI had to label\neverything by hand!",
          "BILL: Some people collect\nstamps.\fI collect POKEMON\ndata.\fTakes up less shelf\nspace!",
          "BILL: My PC network\nnever sleeps.\fWish I could say\nthe same for me!",
          "BILL: Ever wonder what\nhappens inside a PC?\fTrust me.\fIt's less exciting\nthan it sounds.",
          "BILL: I started all this\nbecause I love\nPOKEMON.\fThen the computers\nkind of took over!",
          "BILL: CELADON has better\nshops...\fBut you can't beat\nthe view up here!",
          "BILL: CERULEAN CAPE is\npretty quiet.\fThat's exactly why\nI built here!",
          "BILL: My grandpa worries\nI work too much.\fHe's probably right.\fDon't tell him I said\nthat!",
          "BILL: EEVEE really is\nremarkable.\fSo many possibilities\nin one little POKEMON!",
          "BILL: Evolution isn't\nalways about levels.\fPOKEMON keep finding\nways to surprise us!",
          "BILL: I once tried to\norganize my notes.\fThree days later I\nhad more notes.",
          "BILL: Technology is\nincredible!\f...PROF.OAK says that\na lot too, doesn't he?",
          "BILL: RED!\fIf you ever invent\nsomething, test it\ncarefully.\fPreferably before you\nclimb inside it.",
          "BILL: Becoming a POKEMON\nwas educational.\fI don't recommend it.",
          "BILL: My TELEPORTER still\nmakes me nervous.\fCan you blame me?",
          "BILL: The PC boxes are\ngetting crowded!\fTRAINERS sure do love\ncatching POKEMON.",
          "BILL: I hear strange\nstories from trainers\nall over KANTO.\fMost are nonsense.\fMost.",
          "BILL: LINK technology is\nfascinating.\fTwo machines, miles\napart, sharing POKEMON!",
          "BILL: Trade evolution...\fThere's still a lot we\ndon't understand.\fThat's what makes it\ninteresting!",
          "BILL: That EVOLVE machine\nis holding together.\fMostly.\fThat's a joke, RED!\f...Mostly.",
          "BILL: Every successful\nevolution gives me\nmore data.\fKeep 'em coming!",
          "BILL: I should give that\nmachine a proper name.\fEVOLVE works for now.",
          "BILL: PROF.OAK and I don't\nalways agree.\fThat's usually when\nthe research gets fun!",
          "BILL: RED, you've seen\nmore of KANTO than\nmost researchers.\fDon't stop looking\nfor strange things!",
        }

        local function pickBillLine()
          local last = tonumber(mod.save:get("bill_idle_last_v1"))
          local bag = tostring(mod.save:get("bill_idle_bag_v1") or "")
          local choices = {}
          for n in bag:gmatch("%d+") do choices[#choices + 1] = tonumber(n) end
          if #choices == 0 then
            for i = 1, #billLines do choices[i] = i end
            for i = #choices, 2, -1 do
              local j = love.math.random(i)
              choices[i], choices[j] = choices[j], choices[i]
            end
            if last and #choices > 1 and choices[#choices] == last then
              choices[1], choices[#choices] = choices[#choices], choices[1]
            end
          end
          local index = table.remove(choices)
          mod.save:set("bill_idle_last_v1", index)
          mod.save:set("bill_idle_bag_v1", table.concat(choices, ","))
          return billLines[index]
        end

        if isBill and tradebackUnlocked(game)
          and mod.save:get("tradeback_pc_message_seen_v1")
          and not mod.save:get("tradeback_bill_intro_seen_v1") then
          mod.save:set("tradeback_bill_intro_seen_v1", true)
          npc:facePlayer(self.player)
          local TextBox = require("src.render.TextBox")
          game.stack:push(TextBox.new(game, vpFormatDialogue(
            "BILL: Hey! You got my message!\fI've been working on a new machine.\fIt can help certain POKEMON evolve in a way they normally can't here.\fGive it a try!")))
          return
        end

        -- Once Bill's Tradeback introduction has been seen, normal talks gain
        -- a larger rotating life-dialogue pool. Machine/evolution dialogue is
        -- handled by billsHousePC and therefore always keeps priority.
        if isBill and tradebackUnlocked(game)
          and mod.options:get("oak_postdex_life")
          and mod.save:get("tradeback_bill_intro_seen_v1") then
          npc:facePlayer(self.player)
          local TextBox = require("src.render.TextBox")
          game.stack:push(TextBox.new(game, vpFormatDialogue(pickBillLine())))
          return
        end

        return originalTalkTo(self, npc)
      end

      -- The one-time exclamation belongs to Bill noticing RED arrive, not to
      -- the player pressing A on him.  Entering the cottage after the PC
      -- breadcrumb now triggers the emote once; the actual introduction still
      -- waits for interaction so normal movement/control is never hijacked.
      mod.events:on("map.entered", function()
        local game, ow = gameRef, gameRef and gameRef.overworld
        if not (game and ow and ow.map and ow.map.id == "BILLS_HOUSE") then return end
        if not tradebackUnlocked(game)
          or not mod.save:get("tradeback_pc_message_seen_v1")
          or mod.save:get("tradeback_bill_intro_seen_v1")
          or mod.save:get("tradeback_bill_arrival_emote_v1") then return end
        local bill = ow.npcs and ow.npcs[1]
        if bill then
          mod.save:set("tradeback_bill_arrival_emote_v1", true)
          ow.emote = { npc = bill, frames = 35 }
        end
      end)

      -- The machine itself. Before the feature unlocks, native Bill behavior
      -- runs untouched, preserving the cell separator, SS Ticket, and Eevee
      -- collection sequence.
      function OverworldState:billsHousePC()
        local game = gameRef
        if not tradebackUnlocked(game) then
          return originalBillsHousePC(self)
        end

        local Menu = require("src.ui.Menu")
        local Screens = require("src.ui.Screens")
        local TextBox = require("src.render.TextBox")
        local Evolution = require("src.pokemon.Evolution")

        local function chooseTradeEvolution()
          Screens.push(game, "PartyMenu", {
            pickOnly = true,
            onSwitch = function(mon)
              local target, evo = Evolution.pendingFor(game, mon, { kind = "trade" })
              if not target then
                game.stack:push(TextBox.new(game,
                  vpFormatDialogue("This POKEMON does not react to the machine.")))
                return
              end

              local function runEvolution()
                game.stack:push(TextBox.new(game,
                  vpFormatDialogue("BILL's machine begins to hum..."), function()
                    Evolution.evolve(game, mon, target, function()
                      if not mod.save:get("tradeback_calibrated_v1") then
                        mod.save:set("tradeback_calibrated_v1", true)
                        game.stack:push(TextBox.new(game, vpFormatDialogue(
                          "BILL: ...\fWell...\fI guess it works.\fYou actually saved me a lot of testing.\fFeel free to use it anytime!\fThe research would be invaluable!")))
                      end
                    end, (evo and evo.method) or "TRADE")
                  end))
              end

              -- Approved first-use beat: Bill interrupts only the first
              -- successful Tradeback attempt, then the evolution proceeds.
              if not mod.save:get("tradeback_calibrated_v1") then
                game.stack:push(TextBox.new(game,
                  vpFormatDialogue("BILL: H-Hey!\fWait a second!\fI haven't finished calibrating it yet!"),
                  runEvolution))
              else
                runEvolution()
              end
            end,
          })
        end

        game.stack:push(Menu.new(game, {
          { label = "EVOLVE", onSelect = chooseTradeEvolution },
          { label = "COLLECTION", onSelect = function() self:billsHousePokemonList() end },
          { label = "CANCEL" },
        }, { tx = 8, ty = 6, tw = 11, th = 8 }))
      end
    end
  end

  -- Expanded Fly list: the engine already carries legal Fly landing spots
  -- for Route 4 and Route 10 Centers; vanilla hides them because routes are
  -- filtered out of the town list. Expose them once visited.
  do
    local ok, FlyMenu = pcall(require, "src.ui.FlyMenu")
    if ok and FlyMenu and not FlyMenu._vanillaPlusCentersWrapped then
      FlyMenu._vanillaPlusCentersWrapped = true
      local originalNew = FlyMenu.new
      function FlyMenu.new(game)
        if not mod.options:get("fly_to_centers") then return originalNew(game) end
        local ListMenu = require("src.ui.ListMenu")
        local items, seen = {}, {}
        local visited = game.save.visited or {}
        local allowedRouteCenters = { ROUTE_4 = true, ROUTE_10 = true }
        local Map = require("src.world.Map")
        for _, mapId in ipairs(game.data.field.flyOrder or {}) do
          local def = game.data.maps[mapId]
          if visited[mapId] and def and not seen[mapId]
             and (Map.isFlyTown(def) or allowedRouteCenters[mapId])
             and game.data.field.flyWarps[mapId] then
            seen[mapId] = true
            local label = mapId:gsub("_", " ")
            if mapId == "ROUTE_4" then label = "MT MOON CENTER" end
            if mapId == "ROUTE_10" then label = "ROCK TUNNEL CENTER" end
            items[#items+1] = { value=mapId, label=label }
          end
        end
        return ListMenu.new(game, "FLY TO?", items, { onChoose=function(item,list) list:close(); game.overworld:flyTo(item.value) end })
      end
    end
  end

  -- Follower + Pokemon Center Chansey.  Vanilla+ always keeps the classic
  -- sprite presentation: no Stadium/3D Pokemon models are bundled or requested.
  do
    local Collision = require("src.world.Collision")
    local followerIndex, chanseyIndex = 97, 98

    local function wildsExports()
      local hit = mod.find and mod.find("overworld_wild_spawns")
      return hit and hit.exports
    end

    local function findTagged(ow, tag)
      for _, npc in ipairs(ow and ow.npcs or {}) do
        if npc[tag] then return npc end
      end
    end

    local function removeTagged(ow, tag)
      local npc = findTagged(ow, tag)
      if not npc then return end
      for i = #ow.npcs, 1, -1 do
        if ow.npcs[i] == npc then table.remove(ow.npcs, i) end
      end
      for i = #ow.entities, 1, -1 do
        if ow.entities[i] == npc then table.remove(ow.entities, i) end
      end
    end

    local function spriteName(game, species)
      local sp = tostring(species or ""):upper()
      if (sp == "CHANSEY" or sp == "MR_MIME")
        and game.data.sprites and game.data.sprites.SPRITE_MONSTER then
        return "SPRITE_MONSTER"
      end
      local id = "SPRITE_" .. sp
      if game.data.sprites and game.data.sprites[id] then return id end
      if game.data.sprites and game.data.sprites.SPRITE_MONSTER then return "SPRITE_MONSTER" end
      return nil
    end

    local function skinPokemon(npc, species, game)
      npc.species = species
      npc.enhancedDexId = species
      npc.isFollower = npc.vpFollower == true
      local ex = wildsExports()
      if ex and ex.refreshEntitySprite then
        pcall(ex.refreshEntitySprite, npc, { game = game, reason = "vanillaplus_companion" })
      end
    end

    local function makePokemonNPC(game, ow, species, x, y, index, tag)
      local spr = spriteName(game, species)
      if not spr then return nil end
      local NPC = require("src.world.NPC")
      local npc = NPC.new(game.data, ow.map.id, {
        index = index, name = "VANILLAPLUS_" .. tag:upper(), sprite = spr,
        movement = "STAY", range = "NONE", x = x, y = y, text = 0,
      })
      npc[tag] = true
      -- Followers never trap the player, matching Yellow's passable companion;
      -- they still respect map/NPC collision when THEY choose a step.
      npc.passable = tag == "vpFollower"
      skinPokemon(npc, species, game)
      table.insert(ow.npcs, npc)
      table.insert(ow.entities, npc)
      return npc
    end

    local function monFingerprint(mon)
      if not mon then return nil end
      local d = mon.dvs or {}
      return table.concat({ tostring(mon.otId or 0), tostring(d.attack or -1),
        tostring(d.defense or -1), tostring(d.speed or -1), tostring(d.special or -1) }, ":")
    end

    local function selectedFollower(game)
      local party = game.save.party or {}
      local wanted = mod.save:get("follower_fingerprint")
      if wanted then
        for _, mon in ipairs(party) do
          if monFingerprint(mon) == wanted and (mon.hp or 0) > 0 then return mon end
        end
      end
      for _, mon in ipairs(party) do if (mon.hp or 0) > 0 then return mon end end
      return nil
    end

    local function safeFollowerCell(ow)
      local p = ow.player
      local behind = {
        left  = { 1, 0 }, right = { -1, 0 },
        up    = { 0, 1 }, down  = { 0, -1 },
      }
      local d = behind[p.facing] or { 0, 1 }
      local candidates = {
        { p.cellX + d[1], p.cellY + d[2] },
        { p.cellX - 1, p.cellY }, { p.cellX + 1, p.cellY },
        { p.cellX, p.cellY - 1 }, { p.cellX, p.cellY + 1 },
      }
      for _, c in ipairs(candidates) do
        local x, y = c[1], c[2]
        if ow.map:inBounds(x, y) and ow.map:isWalkableCell(x, y)
          and not ow.map:warpAtCell(x, y)
          and not Collision.occupied(ow.entities, x, y, nil) then
          return x, y
        end
      end
      return p.cellX, p.cellY
    end

    local function syncFollower(fresh)
      local game = gameRef
      local ow = game and game.overworld
      if not ow then return end
      removeTagged(ow, "vpFollower")
      ow.vpFollowerQueue = {}
      ow.vpFollowerWanderTrail = {}
      if not mod.options:get("followers") or game.save.onBike
        or (ow.player and ow.player.surfing) then return end
      local mon = selectedFollower(game)
      if not mon then return end
      local x, y = safeFollowerCell(ow)
      local npc = makePokemonNPC(game, ow, mon.species, x, y, followerIndex, "vpFollower")
      if npc then
        local p = ow.player
        npc.facing = p.facing
        npc.vpMode = "follow"
        npc.vpIdleFrames = 0
        npc.vpBlockedFrames = 0
        ow.vpFollowerTrail = { x = p.cellX, y = p.cellY }
        ow.vpFollowerMap = ow.map.id
      end
    end

    local function sameCell(a, b)
      return a and b and a.x == b.x and a.y == b.y
    end

    local function queueCell(queue, x, y)
      local cell = { x = x, y = y }
      if #queue == 0 or not sameCell(queue[#queue], cell) then
        queue[#queue + 1] = cell
      end
      while #queue > 32 do table.remove(queue, 1) end
    end

    local function startStep(npc, ow, tx, ty, speed)
      local dx, dy = tx - npc.cellX, ty - npc.cellY
      if math.abs(dx) + math.abs(dy) ~= 1 then return false end
      local dir = dx == 1 and "right" or dx == -1 and "left"
        or dy == 1 and "down" or "up"
      if not Collision.canMove(ow.map, ow.entities, npc, dir) then return false end
      if ow.map:warpAtCell(tx, ty) then return false end
      npc.facing = dir
      npc.targetX, npc.targetY = tx, ty
      npc.moving = true
      npc.progress = 0
      npc.stepFrames = speed or 16
      return true
    end

    -- Drive companions from the player's committed step, not from completed
    -- cells. This is the key to Yellow-like movement: the follower starts into
    -- the tile the player is vacating during the same walk animation.
    local NPC = require("src.world.NPC")
    if not NPC._vanillaPlusFollowerV3Wrapped then
      NPC._vanillaPlusFollowerV3Wrapped = true
      local baseUpdate = NPC.update
      function NPC:update(map, entities)
        if not self.vpFollower then return baseUpdate(self, map, entities) end
        local game = gameRef
        local ow = game and game.overworld
        local p = ow and ow.player
        if not ow or not p then return baseUpdate(self, map, entities) end

        if self.moving then
          self.vpIdleFrames = 0
          return baseUpdate(self, map, entities)
        end

        local destX, destY = p.targetX or p.cellX, p.targetY or p.cellY
        local trail = ow.vpFollowerTrail or { x = p.cellX, y = p.cellY }
        ow.vpFollowerTrail = trail
        local playerCommitted = destX ~= trail.x or destY ~= trail.y

        if self.vpMode == "wander" then
          if playerCommitted then
            queueCell(ow.vpFollowerWanderTrail, trail.x, trail.y)
            trail.x, trail.y = destX, destY
          end
          local distance = math.abs(self.cellX - p.cellX) + math.abs(self.cellY - p.cellY)
          if distance > 6 then
            self.vpMode = "follow"
            ow.vpFollowerQueue = ow.vpFollowerWanderTrail or {}
            ow.vpFollowerWanderTrail = {}
            if #ow.vpFollowerQueue == 0 then queueCell(ow.vpFollowerQueue, p.cellX, p.cellY) end
          else
            self.vpWanderTimer = (self.vpWanderTimer or 0) - 1
            if self.vpWanderTimer <= 0 then
              self.vpWanderTimer = love.math.random(28, 80)
              local dirs = { "up", "down", "left", "right" }
              for _ = 1, 4 do
                local dir = dirs[love.math.random(#dirs)]
                local d = Collision.DELTA[dir]
                local tx, ty = self.cellX + d[1], self.cellY + d[2]
                if math.abs(tx - p.cellX) <= 5 and math.abs(ty - p.cellY) <= 5
                  and startStep(self, ow, tx, ty, 16) then
                  return baseUpdate(self, map, entities)
                end
              end
              -- Sometimes just look around instead of walking.
              self.facing = dirs[love.math.random(#dirs)]
            end
            return baseUpdate(self, map, entities)
          end
        end

        if playerCommitted then
          queueCell(ow.vpFollowerQueue, trail.x, trail.y)
          trail.x, trail.y = destX, destY
          self.vpIdleFrames = 0
        else
          self.vpIdleFrames = (self.vpIdleFrames or 0) + 1
        end

        local q = ow.vpFollowerQueue or {}
        while #q > 0 and q[1].x == self.cellX and q[1].y == self.cellY do
          table.remove(q, 1)
        end

        if #q > 0 then
          local goal = q[1]
          local dx, dy = goal.x - self.cellX, goal.y - self.cellY
          local started = false
          if math.abs(dx) + math.abs(dy) == 1 then
            local playerFrames = p.stepFramesCur or p.stepFrames or 16
            local speed = #q >= 2 and math.max(4, math.floor(playerFrames / 2)) or playerFrames
            started = startStep(self, ow, goal.x, goal.y, speed)
          end
          if started then
            self.vpBlockedFrames = 0
            return baseUpdate(self, map, entities)
          end
          self.vpBlockedFrames = (self.vpBlockedFrames or 0) + 1
          -- A dynamic NPC can briefly occupy the player's old tile. Wait for
          -- it rather than phase through it. Only recover after a long stall.
          if self.vpBlockedFrames > 150 then
            local x, y = safeFollowerCell(ow)
            self.cellX, self.cellY, self.px, self.py = x, y, x * 16, y * 16
            ow.vpFollowerQueue = {}
            ow.vpFollowerWanderTrail = {}
            ow.vpFollowerTrail = { x = p.cellX, y = p.cellY }
            self.vpBlockedFrames = 0
          end
          return baseUpdate(self, map, entities)
        end

        if (self.vpIdleFrames or 0) >= 120 then
          self.vpMode = "wander"
          self.vpWanderTimer = 1
          ow.vpFollowerWanderTrail = {}
        end
        return baseUpdate(self, map, entities)
      end
    end

    mod.events:on("map.entered", function() syncFollower(true) end)
    mod.events:on("mod.options_changed", function(ev)
      if ev and ev.mod == mod.id and ev.key == "followers" then syncFollower(false) end
    end)

    -- Party-menu follower selection. The selected Pokemon is fingerprinted by
    -- OT id + DVs so reordering the party does not silently change companions.
    mod.hooks:wrap("ui.party.submenu", function(next, game, items, mon, ctx)
      local out = next(game, items, mon, ctx)
      if not mod.options:get("followers") or not ctx or ctx.battle then return out end
      local already = mod.save:get("follower_fingerprint") == monFingerprint(mon)
      local insertAt = math.max(1, #(out or {}) - 1)
      table.insert(out, insertAt, {
        label = already and "FOLLOWING" or "FOLLOW",
        onSelect = function(chosen, g)
          mod.save:set("follower_fingerprint", monFingerprint(chosen))
          if g and g.overworld then syncFollower(false) end
        end,
      })
      return out
    end)

    local followerLines = {
      "It looks happy to\nbe traveling with\nyou!",
      "It turns toward\nyou expectantly.",
      "It seems curious\nabout this place.",
      "It gives a cheerful\ncry!",
      "It stays close by\nyour side.",
      "It looks around\nwith interest.",
      "It trots a small\ncircle around you.",
      "It seems ready for\nwhatever comes next.",
      "It studies the\nground for a moment.",
      "It looks pleased\nthat you came over.",
      "It wanders back\ntoward you happily.",
      "It watches you\ncarefully.",
    }

    local chanseyLines = {
      "CHANSEY gives you\na cheerful wave.",
      "CHANSEY flips\nthrough some\npaperwork.",
      "CHANSEY carefully\nchecks the medicine\ncabinet.",
      "CHANSEY is\norganizing supplies.",
      "CHANSEY hums while\nstraightening the\nmedicine shelf.",
      "CHANSEY checks a\ntray of POKe BALLS.",
      "CHANSEY gives you\nan encouraging nod.",
      "CHANSEY tidies the\nhealing station.",
      "CHANSEY looks ready\nto help.",
      "CHANSEY gives a\nhappy little bounce.",
      "CHANSEY counts\nmedicine bottles\nunder her breath.",
      "CHANSEY carefully\nfolds a clean towel.",
      "CHANSEY checks the\nhealing machine's\nreadout.",
      "CHANSEY straightens\na stack of patient\nforms.",
      "CHANSEY gives the\nroom a quick once-over.",
      "CHANSEY smiles and\nreturns to her work.",
    }

    local statusLines = {
      PSN = {
        "CHANSEY notices the\npoison right away.\nShe reaches for an\nANTIDOTE.",
        "CHANSEY checks an\nANTIDOTE bottle and\nlooks concerned.",
        "CHANSEY quickly\nsets an ANTIDOTE\nbeside the machine.",
      },
      BRN = {
        "CHANSEY examines the\nburn and reaches for\na BURN HEAL.",
        "CHANSEY prepares a\nBURN HEAL from the\nmedicine cabinet.",
        "CHANSEY gently\nchecks the burn before\nreadying medicine.",
      },
      PAR = {
        "CHANSEY notices the\nparalysis and gets a\nPARLYZ HEAL ready.",
        "CHANSEY checks your\nPOKeMON, then reaches\nfor a PARLYZ HEAL.",
        "CHANSEY sets out a\nPARLYZ HEAL for your\nPOKeMON.",
      },
      SLP = {
        "CHANSEY gently checks\nthe sleeping POKeMON.\nIt seems peaceful.",
        "CHANSEY lowers her\nvoice near your\nsleeping POKeMON.",
        "CHANSEY listens to\nyour sleeping POKeMON\nbreathe, then smiles.",
      },
      FRZ = {
        "CHANSEY spots the ice\nand quickly prepares\nan ICE HEAL.",
        "CHANSEY reaches for\nan ICE HEAL without\nhesitating.",
        "CHANSEY checks the\nfrozen POKeMON and\nreadies an ICE HEAL.",
      },
      FAINT = {
        "CHANSEY looks worried\nabout your fainted\nPOKeMON.",
        "CHANSEY quickly checks\nyour fainted POKeMON\nand waves you toward\nthe healing machine.",
        "CHANSEY gently checks\nyour fainted POKeMON.\nShe looks concerned.",
      },
      LOW = {
        "CHANSEY notices your\nPOKeMON is badly hurt\nand readies supplies.",
        "CHANSEY looks concerned\nabout your POKeMON's\nlow HP.",
        "CHANSEY urges you\ntoward the healing\nmachine.",
      },
      HURT = {
        "CHANSEY notices a few\nscrapes and prepares\nher supplies.",
        "CHANSEY checks your\nteam and gives you a\nreassuring nod.",
      },
      HEALTHY = {
        "CHANSEY checks your\nteam. Everyone looks\nhealthy!",
        "CHANSEY seems pleased\nwith how healthy your\nPOKeMON look.",
      },
    }

    local function chanseyPool()
      local party = gameRef and gameRef.save and gameRef.save.party or {}
      for _, mon in ipairs(party) do if (mon.hp or 0) <= 0 then return statusLines.FAINT end end
      for _, mon in ipairs(party) do
        local maxhp = mon.stats and mon.stats.hp or mon.maxHp or mon.maxHP or mon.hpMax
        if maxhp and maxhp > 0 and (mon.hp or maxhp) / maxhp <= 0.25 then return statusLines.LOW end
      end
      for _, code in ipairs({ "PSN", "BRN", "PAR", "FRZ", "SLP" }) do
        for _, mon in ipairs(party) do if mon.status == code then return statusLines[code] end end
      end
      local anyHurt = false
      for _, mon in ipairs(party) do
        local maxhp = mon.stats and mon.stats.hp or mon.maxHp or mon.maxHP or mon.hpMax
        if maxhp and (mon.hp or maxhp) < maxhp then anyHurt = true break end
      end
      return anyHurt and statusLines.HURT or statusLines.HEALTHY
    end

    -- Shuffle-bag text picker: every line in a pool is seen once before that
    -- pool reshuffles, eliminating the annoying immediate-repeat behavior.
    local function shuffleBag(npc, key, pool)
      npc.vpBags = npc.vpBags or {}
      local bag = npc.vpBags[key]
      if type(bag) ~= "table" or #bag == 0 then
        bag = {}
        for i = 1, #pool do bag[i] = i end
        for i = #bag, 2, -1 do
          local j = love.math.random(i)
          bag[i], bag[j] = bag[j], bag[i]
        end
        npc.vpBags[key] = bag
      end
      return pool[table.remove(bag)]
    end

    local ok, OverworldState = pcall(require, "src.world.OverworldController")
    if ok and OverworldState and not OverworldState._vanillaPlusTalkV3Wrapped then
      OverworldState._vanillaPlusTalkV3Wrapped = true
      local originalTalkTo = OverworldState.talkTo
      function OverworldState:talkTo(npc)
        if npc and (npc.vpFollower or npc.vpChansey) then
          npc:facePlayer(self.player)
          local TextBox = require("src.render.TextBox")
          local pool, key
          if npc.vpChansey then
            pool = chanseyPool()
            key = table.concat(pool, "|"):sub(1, 24)
          else
            pool, key = followerLines, "follower"
          end
          -- Recomp 0.2.55+ can briefly invalidate a captured game stack during
          -- UI transitions. Never dereference it blindly; custom NPC talk should
          -- fail closed rather than crash the entire overworld.
          local g = gameRef
          if g and g.stack and type(g.stack.push) == "function" then
            g.stack:push(TextBox.new(g, vpFormatDialogue(shuffleBag(npc, key, pool))))
          end
          return
        end
        return originalTalkTo(self, npc)
      end
    end

    local function freeCell(ow, x, y, ignore)
      return ow.map:inBounds(x, y) and ow.map:isWalkableCell(x, y)
        and not ow.map:warpAtCell(x, y)
        and not Collision.occupied(ow.entities, x, y, ignore)
    end

    local function relocateBlockingNPC(ow, chansey)
      -- The player needs one clear interaction tile directly below Chansey.
      -- Viridian and Mt. Moon Centers both have vanilla NPC placements that
      -- can occupy it, so move only that blocker to a nearby legal floor tile.
      local ax, ay = chansey.cellX, chansey.cellY + 1
      local blocker = Collision.occupied(ow.entities, ax, ay, chansey)
      if not blocker or blocker == ow.player or blocker.vpChansey or blocker.vpFollower then return end
      local offsets = {
        { -1, 0 }, { 1, 0 }, { -2, 0 }, { 2, 0 },
        { -1, 1 }, { 1, 1 }, { 0, 1 }, { -2, 1 }, { 2, 1 },
      }
      for _, d in ipairs(offsets) do
        local x, y = blocker.cellX + d[1], blocker.cellY + d[2]
        if freeCell(ow, x, y, blocker) then
          blocker.cellX, blocker.cellY = x, y
          blocker.px, blocker.py = x * 16, y * 16
          blocker.targetX, blocker.targetY = nil, nil
          blocker.moving = false
          return
        end
      end
    end

    local function maybeSpawnChansey()
      local game, ow = gameRef, gameRef and gameRef.overworld
      if not ow then return end
      removeTagged(ow, "vpChansey")
      if not mod.options:get("center_chansey") then return end
      local mapId = tostring(ow.map and ow.map.id or ""):upper()
      local isHealingLobby = mapId:find("POKECENTER", 1, true) ~= nil
        or mapId == "INDIGO_PLATEAU_LOBBY"
      if not isHealingLobby then return end
      local nurse
      for _, n in ipairs(ow.npcs or {}) do
        local name = tostring(n.def and n.def.name or ""):upper()
        local spr = tostring(n.def and n.def.sprite or ""):upper()
        if name:find("NURSE", 1, true) or spr:find("NURSE", 1, true) then nurse = n break end
      end
      if not nurse then return end
      local candidates = {
        { nurse.cellX + 1, nurse.cellY },
        { nurse.cellX - 1, nurse.cellY },
      }
      local x, y
      for _, c in ipairs(candidates) do
        if ow.map:inBounds(c[1], c[2]) and not Collision.occupied(ow.entities, c[1], c[2], nurse) then
          x, y = c[1], c[2]
          break
        end
      end
      if not x then return end
      local npc = makePokemonNPC(game, ow, "CHANSEY", x, y, chanseyIndex, "vpChansey")
      if npc then
        npc.passable = false
        npc.facing = "down"
        relocateBlockingNPC(ow, npc)
      end
    end
    mod.events:on("map.entered", function() maybeSpawnChansey() end)
  end


  local ActionChoice = {}
  ActionChoice.__index = ActionChoice
  function ActionChoice.new(game, entries)
    return setmetatable({ game = game, entries = entries, index = 1 }, ActionChoice)
  end
  function ActionChoice:update()
    local input = self.game.input
    if input:wasPressed("up") then
      self.index = self.index == 1 and #self.entries or self.index - 1
    elseif input:wasPressed("down") then
      self.index = self.index == #self.entries and 1 or self.index + 1
    elseif input:wasPressed("b") then
      self.game.stack:pop()
    elseif input:wasPressed("a") then
      local entry = self.entries[self.index]
      self.game.stack:pop()
      if entry and entry.action then entry.action() end
    end
  end
  function ActionChoice:draw()
    local Font = require("src.render.Font")
    local Theme = require("src.ui.Theme")
    local h = #self.entries * 2 + 1
    local ty = math.max(0, 18 - h)
    local widest = 0
    for _, entry in ipairs(self.entries) do
      widest = math.max(widest, #(entry.label or ""))
    end
    local tw = math.min(20, math.max(7, widest + 3))
    local tx = math.max(0, 20 - tw)
    Font.drawBox(tx, ty, tw, h)
    love.graphics.setColor(0, 0, 0, 1)
    for i, entry in ipairs(self.entries) do
      Font.draw(entry.label, (tx + 2) * 8, (ty + 1 + (i - 1) * 2) * 8)
    end
    Font.drawCode(Theme.cursor, (tx + 1) * 8, (ty + 1 + (self.index - 1) * 2) * 8)
    love.graphics.setColor(1, 1, 1, 1)
  end

  local function bestRod(save)
    local inv = save and save.inventory or {}
    if inv.SUPER_ROD then return "SUPER_ROD" end
    if inv.GOOD_ROD then return "GOOD_ROD" end
    if inv.OLD_ROD then return "OLD_ROD" end
  end

  mod.events:on("world.interacted", function(ev)
    if mod.options:get("adventurers_toolkit") and toolkitUnlocked(g) then return end
    if not mod.options:get("field_shortcuts") or not ev or ev.kind ~= "none" then return end
    local game = gameRef
    local ow = game and game.stack and game.stack:top()
    if not ow or not ow.player or not ow.map or ow.map.id ~= ev.mapId then return end
    local fx, fy = ev.x, ev.y

    local cutState = ow.useCutFieldMove and ow:useCutFieldMove() or "nothing"
    -- Keep valid grass interaction, but describe grass as grass instead of
    -- pretending every CUT-compatible tile is a tree.
    local ts = ow.map.def and ow.map.def.tileset
    local tile = ow.map:inBounds(fx,fy) and ow.map:cellTile(fx,fy) or nil
    local isGrass = (ts == "OVERWORLD" and tile == 0x52)
    local isTree = (ts == "OVERWORLD" and tile == 0x3d)
      or (ts == "GYM" and tile == 0x50)

    if cutState == "ok" then
      game.stack:push(ActionChoice.new(game, {
        { label = "CUT", action = function() ow:tryCut(fx, fy) end },
        { label = "CANCEL" },
      }))
      return
    elseif isGrass then
      local TextBox = require("src.render.TextBox")
      game.stack:push(TextBox.new(game, vpFormatDialogue("This grass could be CUT down!")))
      return
    elseif isTree then
      local TextBox = require("src.render.TextBox")
      game.stack:push(TextBox.new(game, vpFormatDialogue("This tree could be CUT down!")))
      return
    end

    -- Map:isWaterCell classifies raw tile IDs. Those IDs are reused by indoor
    -- tilesets, so furniture can look like water unless we also apply the
    -- engine's canonical water-tileset gate.
    local waterTileset = ow.tilesetHasWater and ow:tilesetHasWater() or false
    local facingWater = waterTileset
      and ow.map:inBounds(fx, fy)
      and ow.map:isWaterCell(fx, fy)
    if not facingWater then return end
    local entries = {}
    if ow.useSurfFieldMove and ow:useSurfFieldMove() == "ok" then
      entries[#entries + 1] = { label = "SURF", action = function() ow:trySurf(fx, fy) end }
    end
    local rod = bestRod(game.save)
    if rod then
      entries[#entries + 1] = { label = "FISH", action = function() ow:goFishing(rod) end }
    end
    if #entries == 0 then
      local TextBox = require("src.render.TextBox")
      game.stack:push(TextBox.new(game, "The water is a\ndeep blue...\nA POKeMON may be\nable to SURF here."))
      return
    end
    entries[#entries + 1] = { label = "CANCEL" }
    game.stack:push(ActionChoice.new(game, entries))
  end)


  -- -----------------------------------------------------------------------
  -- Beta 1 QoL / anime-flavor systems
  -- -----------------------------------------------------------------------
  do
    local Bag = require("src.inventory.Bag")
    local ItemEffects = require("src.inventory.ItemEffects")
    local Menu = require("src.ui.Menu")
    local TextBox = require("src.render.TextBox")
    local NPC = require("src.world.NPC")
    local OverworldState = require("src.world.OverworldController")

    local TOOLKIT_ID = "VP_ADVENTURERS_TOOLKIT"
    local TOOLKIT_NAME = "TOOLKIT"
    local LAPTOP_ID = "VP_TOOLKIT_LAPTOP"

    local function toolkitItemOwned(g)
      local inv = g and g.save and g.save.inventory
      return inv and (inv[TOOLKIT_ID] or 0) > 0 or false
    end

    local function toolkitUnlocked(g)
      return mod.options:get("adventurers_toolkit")
        and (mod.save:get("toolkit_received_v1") == true or toolkitItemOwned(g))
    end

    local function playerName()
      return gameRef and gameRef.save and gameRef.save.player
        and gameRef.save.player.name or "RED"
    end

    local function removeTagged(ow, key)
      if not ow then return end
      for i = #(ow.npcs or {}), 1, -1 do
        if ow.npcs[i][key] then table.remove(ow.npcs, i) end
      end
      for i = #(ow.entities or {}), 1, -1 do
        if ow.entities[i][key] then table.remove(ow.entities, i) end
      end
    end

    local function nearbyFreeCell(ow, originX, originY)
      local Collision = require("src.world.Collision")
      local offsets = {
        { 0, 1 }, { -1, 0 }, { 1, 0 }, { 0, -1 },
        { -1, 1 }, { 1, 1 }, { -2, 0 }, { 2, 0 },
      }
      for _, d in ipairs(offsets) do
        local x, y = originX + d[1], originY + d[2]
        if ow.map:inBounds(x, y) and ow.map:isWalkableCell(x, y)
          and not ow.map:warpAtCell(x, y)
          and not Collision.occupied(ow.entities, x, y, nil) then
          return x, y
        end
      end
    end

    local function addRuntimeNPC(ow, tag, sprite, x, y, movement)
      if not (ow and gameRef and gameRef.data.sprites
        and gameRef.data.sprites[sprite]) then return nil end
      local npc = NPC.new(gameRef.data, ow.map.id, {
        index = tag == "vpAide" and 95 or 96,
        name = "VANILLAPLUS_" .. tag:upper(),
        sprite = sprite,
        movement = movement or "STAY",
        range = movement == "WALK" and "ANY_DIR" or "NONE",
        x = x, y = y, text = 0,
      })
      npc[tag] = true
      npc.passable = false
      table.insert(ow.npcs, npc)
      table.insert(ow.entities, npc)
      return npc
    end

    -- Running Shoes: Oak-style Pallet interception -------------------------
    -- After the opening rival fight, Red can leave the Lab normally. When he
    -- first reaches the north edge of Pallet, Oak's aide catches up from
    -- behind, gives the Running Shoes + 5 Poke Balls, then walks away alone.
    --
    -- Hotfix2 deliberately uses a fresh v2 completion flag so an existing
    -- Hotfix1 test save can exercise this revised scene without a new save.
    local aideCutscene = nil
    local aideApproachFailed = false

    local function startNpcStep(npc, dir)
      local Collision = require("src.world.Collision")
      local d = Collision.DELTA[dir]
      if not d then return false end
      npc.facing = dir
      npc.targetX = npc.cellX + d[1]
      npc.targetY = npc.cellY + d[2]
      npc.moving = true
      npc.progress = 0
      npc.wanders = false
      return true
    end

    local function removeAide(ow, aide)
      if not ow or not aide then return end
      for i = #(ow.npcs or {}), 1, -1 do
        if ow.npcs[i] == aide then table.remove(ow.npcs, i) end
      end
      for i = #(ow.entities or {}), 1, -1 do
        if ow.entities[i] == aide then table.remove(ow.entities, i) end
      end
    end

    -- Build authored-looking Pallet movement using the live map geometry.
    -- Recomp's wider/voxel cameras can keep the aide visible far beyond the
    -- original Game Boy viewport, so both his approach and return now follow
    -- real walkable cells and explicitly avoid signs/warps.
    local function aideRoute(ow, aide, goals)
      if not (ow and ow.map and ow.map.def and aide and goals) then return nil end
      local Collision = require("src.world.Collision")
      local width = ow.map.widthCells or 0
      if width <= 0 then return nil end

      local function key(x, y) return y * width + x end
      local goalSet = {}
      for _, g in ipairs(goals) do
        if ow.map:inBounds(g[1], g[2]) and ow.map:isWalkableCell(g[1], g[2])
          and not (ow.map.signAtCell and ow.map:signAtCell(g[1], g[2]))
          and not Collision.occupied(ow.entities, g[1], g[2], aide) then
          goalSet[key(g[1], g[2])] = true
        end
      end
      if next(goalSet) == nil then return nil end

      local function openCell(x, y)
        if not ow.map:inBounds(x, y) or not ow.map:isWalkableCell(x, y) then
          return false
        end
        -- Signs are interactable map objects rather than collision walls.
        -- Treat them as solid for the cutscene so the aide deliberately walks
        -- around Blue's house sign instead of phasing through it.
        if ow.map.signAtCell and ow.map:signAtCell(x, y) then return false end
        -- Do not cross door/connection warps while walking to a destination.
        if ow.map:warpAtCell(x, y) and not goalSet[key(x, y)] then return false end
        if Collision.occupied(ow.entities, x, y, aide) then return false end
        return true
      end

      local dirs = {
        { "down", 0, 1 },
        { "left", -1, 0 },
        { "right", 1, 0 },
        { "up", 0, -1 },
      }
      local q = { { aide.cellX, aide.cellY } }
      local head = 1
      local startKey = key(aide.cellX, aide.cellY)
      local seen = { [startKey] = true }
      local prev, prevDir = {}, {}
      local finishKey

      while head <= #q do
        local cur = q[head]
        head = head + 1
        local cx, cy = cur[1], cur[2]
        local ck = key(cx, cy)
        if goalSet[ck] then
          finishKey = ck
          break
        end
        for _, d in ipairs(dirs) do
          local nx, ny = cx + d[2], cy + d[3]
          local nk = key(nx, ny)
          if not seen[nk] and openCell(nx, ny) then
            seen[nk] = true
            prev[nk] = ck
            prevDir[nk] = d[1]
            q[#q + 1] = { nx, ny }
          end
        end
      end

      if not finishKey then return nil end
      local reversed = {}
      local cursor = finishKey
      while cursor ~= startKey do
        reversed[#reversed + 1] = prevDir[cursor]
        cursor = prev[cursor]
        if not cursor then return nil end
      end
      local route = {}
      for i = #reversed, 1, -1 do route[#route + 1] = reversed[i] end
      return route
    end

    local function aideRouteToLab(ow, aide)
      local labWarp
      for _, w in ipairs((ow.map.def and ow.map.def.warps) or {}) do
        if w.destMap == "OAKS_LAB" then labWarp = w break end
      end
      if not labWarp then return nil end
      -- Stop outside the door rather than stepping onto the warp itself.
      return aideRoute(ow, aide, {
        { labWarp.x, labWarp.y + 1 },
        { labWarp.x, labWarp.y + 2 },
        { labWarp.x - 1, labWarp.y + 1 },
        { labWarp.x + 1, labWarp.y + 1 },
        { labWarp.x - 1, labWarp.y + 2 },
        { labWarp.x + 1, labWarp.y + 2 },
      })
    end

    local function aideRouteToPlayer(ow, aide)
      local p = ow.player
      if not p then return nil end
      -- Prefer one tile below Red, with side-adjacent fallbacks if another
      -- object occupies that cell in a particular version/layout.
      return aideRoute(ow, aide, {
        { p.cellX, p.cellY + 1 },
        { p.cellX - 1, p.cellY },
        { p.cellX + 1, p.cellY },
        { p.cellX - 1, p.cellY + 1 },
        { p.cellX + 1, p.cellY + 1 },
      })
    end

    local function safeAideSpawnCell(ow)
      local p = ow.player
      if not p then return nil end
      local Collision = require("src.world.Collision")
      -- Beta 1: restore earlier beta's confirmed-working entrance staging.
      -- The long Lab-side entrance introduced a route-failure retry loop.
      -- Keep the safe sign/warp checks and prioritize release stability.
      local offsets = {
        { 0, 4 }, { -1, 4 }, { 1, 4 },
        { 0, 5 }, { -1, 5 }, { 1, 5 },
        { -2, 4 }, { 2, 4 }, { 0, 3 },
      }
      for _, d in ipairs(offsets) do
        local x, y = p.cellX + d[1], p.cellY + d[2]
        if ow.map:inBounds(x, y) and ow.map:isWalkableCell(x, y)
          and not (ow.map.signAtCell and ow.map:signAtCell(x, y))
          and not ow.map:warpAtCell(x, y)
          and not Collision.occupied(ow.entities, x, y, nil) then
          return x, y
        end
      end
      return nil
    end

    local function finishAideGift(ow, aide)
      mod.save:set("running_shoes_received_v1", true)
      mod.save:set("running_shoes_received_v2", true)
      local route = aideRouteToLab(ow, aide) or {}
      aideCutscene = {
        phase = "leave",
        ow = ow,
        aide = aide,
        route = route,
        routeIndex = 1,
      }
      if #route > 0 then
        startNpcStep(aide, route[1])
      else
        -- Fail gracefully rather than letting a future map-layout change
        -- march the aide through scenery. The gift is already complete.
        removeAide(ow, aide)
        aideCutscene = nil
      end
    end

    local function showAideDialogue(ow, aide)
      aide:facePlayer(ow.player)
      gameRef.stack:push(TextBox.new(gameRef,
        "AIDE: Hey! Wait!\fPROF.OAK asked me\nto catch you before\nyou left town.\fTake these with you.\nThey'll make your\ntrip a little easier.",
        function()
          local gotBalls = Bag.add(gameRef.save, "POKE_BALL", 5, gameRef.data)
          local msg = playerName() .. " got the\nRUNNING SHOES!"
          if gotBalls then
            msg = msg .. "\f" .. playerName() .. " got\n5 POKe BALLS!"
          else
            msg = msg .. "\fYour BAG is full!\fThe AIDE couldn't\ngive you the\nPOKe BALLS."
          end
          gameRef.stack:push(TextBox.new(gameRef, msg, function()
            finishAideGift(ow, aide)
          end))
        end))
    end

    local function beginAideApproach(ow, aide)
      local route = aideRouteToPlayer(ow, aide) or {}
      aideCutscene = {
        phase = "approach",
        ow = ow,
        aide = aide,
        route = route,
        routeIndex = 1,
      }
      if #route > 0 then
        startNpcStep(aide, route[1])
      else
        -- Beta 1 safety: never retry a failed route every frame. That retry loop
        -- could lock the overworld. Remove the actor and suppress this trigger
        -- until Pallet is re-entered / the runtime scene is rebuilt.
        removeAide(ow, aide)
        aideCutscene = nil
        aideApproachFailed = true
      end
    end

    local function spawnPalletAide()
      local ow = gameRef and gameRef.overworld
      if not (ow and ow.map and ow.map.id == "PALLET_TOWN" and ow.player) then return end

      local sprite = gameRef.data.sprites.SPRITE_SCIENTIST and "SPRITE_SCIENTIST"
        or (gameRef.data.sprites.SPRITE_OAK and "SPRITE_OAK")
      if not sprite then return end

      local sx, sy = safeAideSpawnCell(ow)
      if not sx then return end

      local aide = addRuntimeNPC(ow, "vpAide", sprite, sx, sy, "STAY")
      if not aide then return end
      aide.wanders = false
      aide.facing = "up"

      aideCutscene = { phase = "emote", ow = ow, aide = aide }
      ow.emote = {
        npc = aide,
        frames = 35,
        onDone = function() beginAideApproach(ow, aide) end,
      }
    end

    local function shouldTriggerPalletAide(ow)
      if not mod.options:get("running_shoes") then return false end
      if mod.save:get("running_shoes_received_v2") then return false end
      if aideCutscene or aideApproachFailed then return false end
      if not (ow and ow.map and ow.map.id == "PALLET_TOWN" and ow.player) then return false end
      -- Beta 1 progression gate: the aide must not intercept Red on the first
      -- Viridian Parcel trip. Recomp++ 0.2.10 exposes the vanilla Gen I
      -- EVENT_GOT_POKEDEX flag for Red/Blue/Yellow, set only after Oak's
      -- Parcel/Pokedex handoff is complete.
      if not (gameRef and gameRef.save and gameRef.save.flags
        and gameRef.save.flags.EVENT_GOT_POKEDEX) then return false end

      -- Trigger when Red next reaches Pallet's north edge after receiving the
      -- Pokedex. This preserves the established "Oak sent me after you" scene
      -- without interfering with the Parcel sequence.
      return ow.player.cellY <= 1
    end

    if not OverworldState._vanillaPlusPalletAideV2Wrapped then
      OverworldState._vanillaPlusPalletAideV2Wrapped = true
      local originalUpdateForAideV2 = OverworldState.update

      function OverworldState:update(...)
        if shouldTriggerPalletAide(self) then
          spawnPalletAide()
          return
        end

        if aideCutscene and aideCutscene.ow == self then
          local cs, aide = aideCutscene, aideCutscene.aide

          -- While the sequence is active we intentionally do not call the
          -- normal overworld update, which keeps Red planted in place.
          if cs.phase == "emote" then
            if self.emote then
              self.emote.frames = self.emote.frames - 1
              if self.emote.frames <= 0 then
                local done = self.emote.onDone
                self.emote = nil
                if done then done() end
              end
            end
            return
          end

          if cs.phase == "approach" then
            aide:update(self.map, self.entities)
            if not aide.moving then
              cs.routeIndex = (cs.routeIndex or 1) + 1
              local nextDir = cs.route and cs.route[cs.routeIndex]
              if nextDir then
                startNpcStep(aide, nextDir)
              else
                cs.phase = "dialogue"
                showAideDialogue(self, aide)
              end
            end
            return
          end

          if cs.phase == "dialogue" then
            -- TextBox owns input while present. Keep Red/NPC world frozen.
            return
          end

          if cs.phase == "leave" then
            aide:update(self.map, self.entities)
            if not aide.moving then
              cs.routeIndex = (cs.routeIndex or 1) + 1
              local nextDir = cs.route and cs.route[cs.routeIndex]
              if nextDir then
                startNpcStep(aide, nextDir)
              else
                -- He has visibly reached the Oak's Lab entrance area.
                removeAide(self, aide)
                aideCutscene = nil
              end
            end
            return
          end
        end

        return originalUpdateForAideV2(self, ...)
      end
    end

    -- DIAG32: finished Saffron Pokemon Center dojo-trader feature.
    -- The NPC uses the same proven runtime-NPC path as the Pallet Aide and a
    -- native Fighting Dojo human sprite. He exists only after the Karate Master
    -- is beaten AND Red has actually taken one of the two Dojo prizes. The
    -- vanilla prize flag determines which Hitmon he owns/offers, while a
    -- Vanilla+ completion flag makes the Primeape trade one-time.
    local function dojoTraderSprite()
      local data = gameRef and gameRef.data
      if not data then return nil end
      local dojo = data.maps and data.maps.FIGHTING_DOJO
      for _, obj in ipairs((dojo and dojo.objects) or {}) do
        local name = tostring(obj.name or ""):upper()
        if (name:find("BLACKBELT", 1, true) or name:find("KARATE_MASTER", 1, true))
          and obj.sprite and data.sprites and data.sprites[obj.sprite] then
          return obj.sprite
        end
      end
      if data.sprites and data.sprites.SPRITE_HIKER then return "SPRITE_HIKER" end
      if data.sprites and data.sprites.SPRITE_GYM_GUIDE then return "SPRITE_GYM_GUIDE" end
      return nil
    end

    local function dojoPrizeChoice()
      local save = gameRef and gameRef.save
      local flags = save and save.flags or {}
      if not flags.EVENT_BEAT_KARATE_MASTER then return nil end
      if flags.EVENT_GOT_HITMONLEE then
        return "HITMONLEE", "HITMONCHAN"
      elseif flags.EVENT_GOT_HITMONCHAN then
        return "HITMONCHAN", "HITMONLEE"
      end
      return nil
    end

    local function maybeSpawnSaffronDojoTrader()
      local ow = gameRef and gameRef.overworld
      if not (ow and ow.map and ow.map.id == "SAFFRON_POKECENTER" and ow.player) then return end
      removeTagged(ow, "vpDojoTrader")
      local chosen, offered = dojoPrizeChoice()
      if not chosen then return end
      local sprite = dojoTraderSprite()
      if not sprite then return end

      -- Keep him beside the PC/corner-counter side and completely out of the
      -- entrance lane. nearbyFreeCell preserves collision safety if a data
      -- pack shifts an object by a tile.
      local x, y = nearbyFreeCell(ow, 1, 2)
      if not x then x, y = nearbyFreeCell(ow, 2, 2) end
      if not x then x, y = nearbyFreeCell(ow, 1, 3) end
      if not x then return end

      local npc = addRuntimeNPC(ow, "vpDojoTrader", sprite, x, y, "STAY")
      if npc then
        npc.wanders = false
        npc.facing = "down"
        npc.vpDojoChosen = chosen
        npc.vpDojoOffer = offered
      end
    end

    local function dojoSpeciesName(id)
      local def = gameRef and gameRef.data and gameRef.data.pokemon and gameRef.data.pokemon[id]
      return (def and def.name) or id
    end

    local function dojoTraderText(msg, done)
      gameRef.stack:push(TextBox.new(gameRef, vpFormatDialogue(msg), done))
    end

    -- DIAG37: Recomp++ 0.1.90's stock TradeAnim is confirmed broken even
    -- for cartridge NPC trades on iOS. Keep the normal Blackbelt offer,
    -- party selection and Gen I NPC-trade state changes, but bypass only the
    -- broken cable cinematic. The transaction happens after the stock cable
    -- prompt, then a short text confirmation replaces TradeAnim.
    local function finishDojoTradeWithoutAnim(sent, offered)
      local party = gameRef.save and gameRef.save.party or {}
      local slot
      for i, mon in ipairs(party) do
        if mon == sent then slot = i break end
      end
      if not slot then return end

      local Pokemon = require("src.pokemon.Pokemon")
      local Sound = require("src.core.Sound")
      local received = Pokemon.new(gameRef.data, offered, sent.level)
      received.nickname = nil
      received.traded = true
      received.ot = "TRAINER"
      received.otId = (love.math and love.math.random or math.random)(0, 65535)

      table.remove(party, slot)
      table.insert(party, received)

      local dex = gameRef.save.pokedex
      if dex then
        dex.seen[offered] = true
        dex.owned[offered] = true
      end
      mod.save:set("dojo_primeape_trade_complete_v1", true)

      -- Keep the native post-trade reward sound, but replace the malformed
      -- TradeAnim screen with a compact confirmation before the Blackbelt's
      -- thanks line.
      Sound.play(gameRef.data, "Get_Key_Item")
      dojoTraderText(playerName() .. " traded PRIMEAPE\nfor " .. dojoSpeciesName(offered) .. "!", function()
        dojoTraderText("BLACKBELT: Hah! This PRIMEAPE has spirit! Now THIS is more my style!")
      end)
    end

    local function openDojoTradePartyWithoutAnim(offered)
      local Screens = require("src.ui.Screens")
      Screens.push(gameRef, "PartyMenu", {
        pickOnly = true,
        onCancel = function()
          dojoTraderText("BLACKBELT: Hmph. Suit yourself.")
        end,
        onSwitch = function(mon)
          if not mon or mon.species ~= "PRIMEAPE" then
            dojoTraderText("BLACKBELT: That's not a PRIMEAPE!")
            return
          end
          -- Commands.trade shows the cartridge cable prompt immediately
          -- before creating the received Pokemon and entering TradeAnim.
          -- Preserve that transition text, then perform the same transaction
          -- and intentionally skip the broken screen.
          local raw = gameRef.data and gameRef.data.text and gameRef.data.text["_ConnectCableText"]
          local cableText = raw and TextBox.substitute(gameRef, raw) or "Okay, connect the cable!"
          gameRef.stack:push(TextBox.new(gameRef, cableText, function()
            finishDojoTradeWithoutAnim(mon, offered)
          end))
        end,
      })
    end

    local function beginDojoTraderConversation(npc)
      local offered = npc.vpDojoOffer
      if not offered then return end
      local offeredName = dojoSpeciesName(offered)
      if mod.save:get("dojo_primeape_trade_complete_v1") then
        dojoTraderText("BLACKBELT: PRIMEAPE's training is coming along great! That temper really keeps me on my toes!")
        return
      end

      dojoTraderText("BLACKBELT: Bah! My " .. offeredName ..
        " can't get the hang of KARATE!\fThat PRIMEAPE of yours looks tough!\fWant to trade?", function()
        gameRef.stack:push(Menu.new(gameRef, {
          { label = "YES", onSelect = function()
              openDojoTradePartyWithoutAnim(offered)
            end },
          { label = "NO", onSelect = function()
              dojoTraderText("BLACKBELT: Hmph. Suit yourself.")
            end },
        }, { tx = 12, ty = 6, tw = 7, th = 6 }))
      end)
    end

    if not OverworldState._vanillaPlusDojoTraderWrapped then
      OverworldState._vanillaPlusDojoTraderWrapped = true
      local previousTalkToDojoTrader = OverworldState.talkTo
      function OverworldState:talkTo(npc)
        if npc and npc.vpDojoTrader then
          npc:facePlayer(self.player)
          beginDojoTraderConversation(npc)
          return
        end
        return previousTalkToDojoTrader(self, npc)
      end
    end

    mod.events:on("map.entered", function()
      maybeSpawnSaffronDojoTrader()
    end)

    -- Permanent CUT trees. Only real trees/plants persist; tall grass keeps
    -- vanilla temporary behavior.
    if not OverworldState._vanillaPlusPermanentCutWrapped then
      OverworldState._vanillaPlusPermanentCutWrapped = true
      local originalTryCut = OverworldState.tryCut
      function OverworldState:tryCut(fx, fy)
        local record
        if mod.options:get("permanent_cut_trees") and self.map
          and self.map:inBounds(fx, fy) then
          local ts = self.map.def.tileset
          local tile = self.map:cellTile(fx, fy)
          local isTree = (ts == "OVERWORLD" and tile == 0x3d)
            or (ts == "GYM" and tile == 0x50)
          if isTree then
            local bx, by = math.floor(fx / 2), math.floor(fy / 2)
            local block = self.map:blockAt(bx, by)
            for _, sw in ipairs(gameRef.data.field.cutTreeSwaps or {}) do
              if sw.before == block then
                record = { map = self.map.id, bx = bx, by = by, after = sw.after }
                break
              end
            end
          end
        end
        local ok = originalTryCut(self, fx, fy)
        if ok and record then
          local all = mod.save:get("permanent_cut_blocks_v1")
          if type(all) ~= "table" then all = {} end
          local key = record.map .. ":" .. record.bx .. ":" .. record.by
          all[key] = record
          mod.save:set("permanent_cut_blocks_v1", all)
        end
        return ok
      end
    end

    local function applyPermanentCuts(ow)
      if not mod.options:get("permanent_cut_trees") then return end
      ow = ow or (gameRef and gameRef.overworld)
      local all = mod.save:get("permanent_cut_blocks_v1")
      if not (ow and ow.map and type(all) == "table") then return end
      local changed = false
      for _, c in pairs(all) do
        if c.map == ow.map.id and ow.map:blockAt(c.bx, c.by) ~= c.after then
          ow.map:setBlock(c.bx, c.by, c.after)
          changed = true
        end
      end
      if changed and ow.map.renderer then ow.map.renderer:rebuild() end
      ow._vanillaPlusPermanentAppliedMap = ow.map.id
    end
    mod.events:on("map.entered", function() applyPermanentCuts() end)

    -- map.entered can fire before Game.overworld has finished swapping on some
    -- Recomp 2 transitions. Re-apply on the first live update of each map too.
    if not OverworldState._vanillaPlusPermanentReplayWrapped then
      OverworldState._vanillaPlusPermanentReplayWrapped = true
      local previousUpdatePermanent = OverworldState.update
      function OverworldState:update(...)
        if self.map and self._vanillaPlusPermanentAppliedMap ~= self.map.id then
          applyPermanentCuts(self)
        end
        return previousUpdatePermanent(self, ...)
      end
    end

    -- Toolkit helpers -------------------------------------------------------
    local toolkitVisual = { kind = nil, frames = 0 }
    local flashlightActive = false
    local flashlightRebaking = false
    local surfboardActive = false
    local balloonActive = false

    local function show(msg, done)
      gameRef.stack:push(TextBox.new(gameRef, msg, done))
    end

    -- Post-Champion Toolkit consolidation. Vanilla scripts keep their real
    -- ownership state in save.inventory; Vanilla+ removes Toolkit-managed
    -- gear, access items, and machines from normal Bag/PC presentation.
    -- This lets old saves migrate automatically without duplicating items.
    local TOOLKIT_FISHING_ITEMS = {
      "OLD_ROD", "GOOD_ROD", "SUPER_ROD",
    }
    local TOOLKIT_EQUIPMENT_ITEMS = {
      "BICYCLE", "TOWN_MAP", "ITEMFINDER", "POKE_FLUTE", "COIN_CASE", "SILPH_SCOPE",
    }
    local TOOLKIT_KEY_ITEMS = {
      "S_S_TICKET", "SECRET_KEY", "CARD_KEY", "LIFT_KEY",
    }
    local CONSOLIDATABLE_KEY_ITEMS = {
      "BICYCLE", "TOWN_MAP", "OLD_ROD", "GOOD_ROD", "SUPER_ROD",
      "ITEMFINDER", "POKE_FLUTE", "COIN_CASE", "SILPH_SCOPE",
      "S_S_TICKET", "SECRET_KEY", "CARD_KEY", "LIFT_KEY",
    }
    local TOOLKIT_FISHING_SET, TOOLKIT_EQUIPMENT_SET, TOOLKIT_KEY_SET = {}, {}, {}
    for _, id in ipairs(TOOLKIT_FISHING_ITEMS) do TOOLKIT_FISHING_SET[id] = true end
    for _, id in ipairs(TOOLKIT_EQUIPMENT_ITEMS) do TOOLKIT_EQUIPMENT_SET[id] = true end
    for _, id in ipairs(TOOLKIT_KEY_ITEMS) do TOOLKIT_KEY_SET[id] = true end

    local KEY_LABEL = {
      BICYCLE = "BICYCLE", TOWN_MAP = "TOWN MAP", OLD_ROD = "OLD ROD", GOOD_ROD = "GOOD ROD",
      SUPER_ROD = "SUPER ROD", ITEMFINDER = "ITEMFINDER",
      POKE_FLUTE = "POKe FLUTE", COIN_CASE = "COIN CASE",
      SILPH_SCOPE = "SILPH SCOPE", S_S_TICKET = "S.S.TICKET",
      SECRET_KEY = "SECRET KEY", CARD_KEY = "CARD KEY",
      LIFT_KEY = "LIFT KEY", [LAPTOP_ID] = "LAPTOP",
      TM_HM_BAG = "TM/HM BAG",
    }
    local function toolkitKeyFlag(id) return "toolkit_key_" .. id .. "_v1" end
    local function toolkitOwns(id) return mod.save:get(toolkitKeyFlag(id)) == true end
    local function isMachineItem(g, id)
      local def = g and g.data and g.data.items and g.data.items[id]
      return type(def) == "table" and type(def.machine) == "table"
    end
    local function toolkitStoredItem(g, id)
      return TOOLKIT_FISHING_SET[id] or TOOLKIT_EQUIPMENT_SET[id] or TOOLKIT_KEY_SET[id] or isMachineItem(g, id)
    end

    -- Portable raw-.sav transfer record -----------------------------------
    -- Recomp's raw Gen I export intentionally omits save.modData. Older
    -- Vanilla+ builds can therefore lose Toolkit-owned machines/key items when
    -- they are squeezed back into the cartridge's 20-slot Bag. The companion
    -- transfer bridge stores a compact record in unused SRAM bank-1 space
    -- (0x3524-0x3fff), outside the vanilla main checksum and all allocated
    -- Red/Blue/Yellow save structures. Restore it here before Toolkit migration.
    local VP_TRANSFER_START = 0x3524 + 1
    local VP_TRANSFER_CAPACITY = 0x4000 - 0x3524
    local VP_TRANSFER_MAGIC = "VPTR1\n"

    local function decodeTransferValue(kind, value)
      if kind == "b" then return value == "1" end
      if kind == "n" then return tonumber(value) end
      return value
    end

    local function restorePortableTransferRecord(g)
      if not (g and g.save) then return false end
      if mod.save:get("portable_transfer_restored_v1") then return false end
      local raw = g.save.rawImport
      if type(raw) ~= "string" or #raw < 0x4000 then return false end
      local region = raw:sub(VP_TRANSFER_START, VP_TRANSFER_START + VP_TRANSFER_CAPACITY - 1)
      if region:sub(1, #VP_TRANSFER_MAGIC) ~= VP_TRANSFER_MAGIC then return false end
      local stop = region:find("\nEND\n", 1, true)
      if not stop then return false end
      local body = region:sub(1, stop + 4)
      g.save.inventory = g.save.inventory or {}

      local restoredItems = 0
      for line in body:gmatch("[^\n]+") do
        local tag, a, b, c = line:match("^([^|]+)|([^|]*)|?([^|]*)|?(.*)$")
        if tag == "F" and a and b then
          local value = decodeTransferValue(b, c or "")
          -- The bridge only writes Vanilla+ Toolkit/Bill/Oak primitive state.
          if a == "registered_key_item_v1"
            or a:match("^toolkit_")
            or a:match("^tradeback_")
            or a:match("^oak_") then
            mod.save:set(a, value)
          end
        elseif tag == "I" and a and b then
          local qty = math.max(0, math.min(99, math.floor(tonumber(b) or 0)))
          if qty > 0 then
            g.save.inventory[a] = math.max(tonumber(g.save.inventory[a]) or 0, qty)
            restoredItems = restoredItems + 1
          end
        end
      end

      -- A previously received Toolkit is a Vanilla+-only item and cannot exist
      -- in cartridge SRAM by itself, so restore its physical ownership mirror.
      if mod.save:get("toolkit_received_v1") then
        g.save.inventory[TOOLKIT_ID] = math.max(1, tonumber(g.save.inventory[TOOLKIT_ID]) or 0)
      end
      mod.save:set("portable_transfer_restored_v1", true)
      mod.save:set("portable_transfer_restored_items_v1", restoredItems)
      return true
    end


    local function consolidateOwnedKeyItems(g)
      if not (g and g.save and toolkitUnlocked(g)) then return 0 end
      g.save.inventory = g.save.inventory or {}
      g.save.pcItems = g.save.pcItems or {}
      local moved = 0

      -- Move Toolkit equipment / access items out of PC storage while keeping
      -- the vanilla inventory ownership mirror scripts already understand.
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do
        local bagQty = g.save.inventory[id] or 0
        local pcQty = g.save.pcItems[id] or 0
        if bagQty > 0 or pcQty > 0 then
          if not toolkitOwns(id) then moved = moved + 1 end
          mod.save:set(toolkitKeyFlag(id), true)
          g.save.inventory[id] = math.min(99, math.max(1, bagQty + pcQty))
          g.save.pcItems[id] = nil
        elseif TOOLKIT_KEY_SET[id] then
          -- Access items can genuinely be consumed/removed by story scripts
          -- (notably the S.S.TICKET), so never leave a stale Toolkit copy.
          mod.save:set(toolkitKeyFlag(id), false)
        end
      end

      -- Machines belong to the TM/HM Bag once the Toolkit exists. Preserve
      -- actual quantities and merge any PC copies so old saves upgrade cleanly.
      local machineIds = {}
      for id in pairs(g.save.pcItems) do
        if isMachineItem(g, id) then machineIds[id] = true end
      end
      for id in pairs(g.save.inventory) do
        if isMachineItem(g, id) then machineIds[id] = true end
      end
      for id in pairs(machineIds) do
        local bagQty = g.save.inventory[id] or 0
        local pcQty = g.save.pcItems[id] or 0
        if pcQty > 0 then
          g.save.inventory[id] = math.min(99, bagQty + pcQty)
          g.save.pcItems[id] = nil
          moved = moved + 1
        end
      end
      return moved
    end

    -- Permanent save-transfer safety: Mom can unpack Toolkit-managed physical
    -- items back into vanilla Bag + PC storage before a raw .sav export.
    -- The operation is transactional and prefers the PC so Gen I's 20-slot Bag
    -- cannot silently discard overflow during transfer/reinstall workflows.
    local function vpCopyTable(src)
      local out = {}
      for k, v in pairs(src or {}) do out[k] = v end
      return out
    end

    local function vpCountPositiveSlots(t)
      local n = 0
      for _, qty in pairs(t or {}) do
        if (tonumber(qty) or 0) > 0 then n = n + 1 end
      end
      return n
    end

    local function packToolkitForTransfer(g)
      if not (g and g.save) then return false, "Save data isn't ready." end
      g.save.inventory = g.save.inventory or {}
      g.save.pcItems = g.save.pcItems or {}
      local bag, pc = vpCopyTable(g.save.inventory), vpCopyTable(g.save.pcItems)
      local packed = {}
      local function collect(id, qty)
        qty = tonumber(qty) or 0
        if qty > 0 then packed[id] = math.min(99, (packed[id] or 0) + qty) end
      end
      for id, qty in pairs(vpCopyTable(bag)) do
        if id == TOOLKIT_ID then bag[id] = nil
        elseif toolkitStoredItem(g, id) then collect(id, qty); bag[id] = nil end
      end
      for id, qty in pairs(vpCopyTable(pc)) do
        if id == TOOLKIT_ID then pc[id] = nil
        elseif toolkitStoredItem(g, id) then collect(id, qty); pc[id] = nil end
      end
      local bagSlots, pcSlots = vpCountPositiveSlots(bag), vpCountPositiveSlots(pc)
      local BAG_LIMIT, PC_LIMIT = 20, 50
      local ordered, seen = {}, {}
      local function push(id)
        if packed[id] and not seen[id] then ordered[#ordered+1]=id; seen[id]=true end
      end
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do push(id) end
      local rest = {}
      for id in pairs(packed) do if not seen[id] then rest[#rest+1]=id end end
      table.sort(rest)
      for _, id in ipairs(rest) do push(id) end
      for _, id in ipairs(ordered) do
        local qty = packed[id]
        if pc[id] then pc[id] = math.min(99, (tonumber(pc[id]) or 0) + qty)
        elseif pcSlots < PC_LIMIT then pc[id]=qty; pcSlots=pcSlots+1
        elseif bag[id] then bag[id] = math.min(99, (tonumber(bag[id]) or 0) + qty)
        elseif bagSlots < BAG_LIMIT then bag[id]=qty; bagSlots=bagSlots+1
        else return false, "Your BAG and PC don't have enough free item slots." end
      end
      g.save.inventory, g.save.pcItems = bag, pc
      mod.save:set("toolkit_transfer_packed_v1", true)
      mod.save:set("toolkit_received_v1", false)
      mod.save:set("registered_key_item_v1", false)
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do mod.save:set(toolkitKeyFlag(id), false) end
      return true, string.format("Packed %d Toolkit item types into BAG + PC.", #ordered)
    end

    local function withConsolidatedInventoryHidden(g, fn)
      if not (g and g.save and toolkitUnlocked(g)) then
        return fn()
      end
      local inv, held = g.save.inventory or {}, {}
      for id, qty in pairs(inv) do
        if toolkitStoredItem(g, id) then
          held[id] = qty
          inv[id] = nil
        end
      end
      local ok, result = pcall(fn)
      for id, qty in pairs(held) do inv[id] = qty end
      if not ok then error(result) end
      return result
    end

    local function useAxe()
      local ow = gameRef and gameRef.overworld
      if not ow or not ow.player then return end
      local fx, fy = ow.player:facingCell()
      if not ow.map:inBounds(fx, fy) then
        return show(vpFormatDialogue("There's nothing here to use the AXE on."))
      end
      local ts = ow.map.def.tileset
      local tile = ow.map:cellTile(fx, fy)
      local isGrass = (ts == "OVERWORLD" and tile == 0x52)
      local isTree = (ts == "OVERWORLD" and tile == 0x3d)
        or (ts == "GYM" and tile == 0x50)
      if not (isTree or isGrass) then
        return show(vpFormatDialogue("There's nothing here to use the AXE on."))
      end
      local bx, by = math.floor(fx / 2), math.floor(fy / 2)
      local block = ow.map:blockAt(bx, by)
      local swap
      for _, sw in ipairs(gameRef.data.field.cutTreeSwaps or {}) do
        if sw.before == block then swap = sw break end
      end
      if not swap then return show("The AXE won't help\nhere.") end
      toolkitVisual.kind, toolkitVisual.frames = "AXE", 24
      show(playerName() .. " used the AXE!", function()
        ow.map:setBlock(bx, by, swap.after)
        if ow.map.renderer then ow.map.renderer:rebuild() end
        -- Trees/plants stay gone; grass keeps Gen I's temporary-cut behavior.
        if isTree then
          local all = mod.save:get("permanent_cut_blocks_v1")
          if type(all) ~= "table" then all = {} end
          all[ow.map.id .. ":" .. bx .. ":" .. by] =
            { map = ow.map.id, bx = bx, by = by, after = swap.after }
          mod.save:set("permanent_cut_blocks_v1", all)
        end
        local finish = function()
          require("src.core.Sound").play(gameRef.data, "Cut")
        end
        if isGrass and ow.startDustAnim then
          ow:startDustAnim(fx, fy, finish)
        elseif ts == "OVERWORLD" and ow.startCutTreeAnim then
          ow:startCutTreeAnim(fx, fy, finish)
        elseif ow.startDustAnim then
          ow:startDustAnim(fx, fy, finish)
        else
          finish()
        end
      end)
    end

    local function useCrowbar()
      local ow = gameRef and gameRef.overworld
      if not ow then return end
      toolkitVisual.kind, toolkitVisual.frames = "CROWBAR", 28
      ow.strengthActive = true
      show(playerName() .. " readied the\nCROWBAR!\fHeavy boulders can\nnow be moved.")
    end

    local function useSurfboard()
      local ow = gameRef and gameRef.overworld
      if not ow or not ow.player then return end
      local p = ow.player
      if p.surfing then
        if ow.facingIsLandDismount and ow:facingIsLandDismount() then
          show(playerName() .. " put the\nSURFBOARD away.", function()
            p.surfing = false
            surfboardActive = false
            if ow.syncSurfingPikachu then ow:syncSurfingPikachu() end
            local Music = require("src.core.Music")
            Music.playMap(gameRef.data, ow.map.id, false, false)
            if ow.stepForwardOrCrossEdge then ow:stepForwardOrCrossEdge(p.facing) end
          end)
        else
          show("There's nowhere to\nget off here.")
        end
        return
      end
      if gameRef.save.forcedBike or (ow.surfBlockedHere and ow:surfBlockedHere()) then
        return show("The SURFBOARD can't\nbe used here.")
      end
      if not (ow.facingIsShoreOrWater and ow:facingIsShoreOrWater()) then
        return show("No surfing here!")
      end
      show(playerName() .. " got on the\nSURFBOARD!", function()
        p.surfing = true
        surfboardActive = true
        gameRef.save.onBike = false
        if ow.syncSurfingPikachu then ow:syncSurfingPikachu() end
        local Music = require("src.core.Music")
        Music.playMap(gameRef.data, ow.map.id, false, true)
        if ow.stepForwardOrCrossEdge then ow:stepForwardOrCrossEdge(p.facing) end
      end)
    end

    local function closeMenusToOverworld(ow)
      if not (gameRef and gameRef.stack and ow) then return end
      local guard = 0
      while gameRef.stack:top() and gameRef.stack:top() ~= ow and guard < 12 do
        gameRef.stack:pop()
        guard = guard + 1
      end
    end

    local function useBalloon()
      local ow = gameRef and gameRef.overworld
      if not ow then return end
      local mapId = ow.map and tostring(ow.map.id or ""):upper() or ""
      local tileset = ow.map and ow.map.def and tostring(ow.map.def.tileset or ""):upper() or ""
      -- Route 23's Indigo Plateau exterior uses a non-OVERWORLD tileset even
      -- though it is an outdoor Fly-capable area. Explicitly allow that map
      -- without relaxing the restriction for the Plateau lobby or caves.
      local plateauExterior = (mapId == "ROUTE_23" or mapId == "INDIGO_PLATEAU")
      if tileset ~= "OVERWORLD" and not plateauExterior then
        return show("You can't unpack the\nHOT AIR BALLOON here.")
      end
      local ok, TownMap = pcall(require, "src.ui.TownMap")
      if not ok or not TownMap then return show("The BALLOON won't\nopen here.") end
      balloonActive = true
      show(playerName() .. " unpacked the\nHOT AIR BALLOON!", function()
        gameRef.stack:push(TownMap.new(gameRef, {
          fly = true,
          onFly = function(mapId)
            closeMenusToOverworld(ow)
            ow:flyTo(mapId)
          end,
        }))
      end)
    end

    local function useFlashlight()
      local ow = gameRef and gameRef.overworld
      if not ow then return end
      -- HOTFIX4-DIAG24: custom directional-light experiments are tabled.
      -- FLASHLIGHT now delegates directly to Recomp's proven native FLASH
      -- field-move path so the Toolkit is stable and complete.
      flashlightActive = false
      if gameRef.save then
        gameRef.save.flashLit = false
        gameRef.save.vpFlashDiag = false
      end
      if not ow.dark then
        return show("It's bright enough\nwithout the\nFLASHLIGHT.")
      end
      if ow.useFlashFieldMove then
        return ow:useFlashFieldMove()
      end
      return show("The FLASHLIGHT won't\nwork here.")
    end

    local openToolkit
    local openTMHMBag

    local function showPayload(payload, done)
      if type(payload) == "table" then payload = table.concat(payload, "\f") end
      show(payload or "It won't have any\neffect.", done)
    end

    local function useStoredKeyItem(id)
      local ow = gameRef and gameRef.overworld
      if not ow then return end
      if id == TOOLKIT_ID then return openToolkit() end
      if id == "TM_HM_BAG" then return openTMHMBag() end
      if id == LAPTOP_ID then
        closeMenusToOverworld(ow)
        if ow.openPC then return ow:openPC() end
        return show("The LAPTOP won't\nconnect here.")
      end
      if not toolkitOwns(id) then return show("That item isn't in\nthe TOOLKIT.") end

      if id == "BICYCLE" then
        if ow.useBicycle then
          if ow:useBicycle() == false then return show("No cycling\nallowed here.") end
          return
        end
        return show("The BICYCLE can't\nbe used here.")
      end

      if id == "OLD_ROD" or id == "GOOD_ROD" or id == "SUPER_ROD" then
        if ow.player and ow.player.surfing then
          return show("OAK: " .. playerName() .. "!\nThis isn't the\ntime to use that!")
        end
        if ow.facingIsShoreOrWater and ow:facingIsShoreOrWater() then
          return ow:goFishing(id)
        end
        return show("No good! It's not\neven near water.")
      end

      if id == "TOWN_MAP" then
        local ok, TownMap = pcall(require, "src.ui.TownMap")
        if not ok or not TownMap then return show("The TOWN MAP won't\nopen here.") end
        gameRef.stack:push(TownMap.new(gameRef, { fly = false }))
        return
      end

      if id == "ITEMFINDER" then
        if ow.hasHiddenItemLeft and ow:hasHiddenItemLeft() then
          return show("Yes! ITEMFINDER\nindicates there's\nan item nearby.")
        end
        return show("Nope! ITEMFINDER\nisn't responding.")
      end

      if id == "POKE_FLUTE" then
        local result, payload, extra = ItemEffects.use(gameRef.data, gameRef.save,
          id, nil, nil, nil, ow)
        local Sound = require("src.core.Sound")
        if result == "flute_field" then
          Sound.play(gameRef.data, "Pokeflute")
          return showPayload(payload)
        elseif result == "flute_wake_pikachu" then
          Sound.play(gameRef.data, "Pokeflute")
          return showPayload(payload, function() ow.pikachuPewterSleepScene = nil end)
        elseif result == "flute_wake" then
          Sound.play(gameRef.data, "Pokeflute")
          return showPayload(payload, function()
            local scripts = require("data.scripts.init").get(extra.mapId)
            if scripts and scripts.snorlaxWake then
              ow.runner:run(scripts.snorlaxWake.script, { npc = extra.npc })
            end
          end)
        end
        return showPayload(payload)
      end

      if id == "COIN_CASE" then
        return show("Coin count:\n" .. tostring((gameRef.save and gameRef.save.coins) or 0))
      end

      if id == "SILPH_SCOPE" then
        return show("The SILPH SCOPE is\nready for use.")
      end
    end

    local function registerKeyItem(id)
      if id ~= TOOLKIT_ID and id ~= LAPTOP_ID and id ~= "TM_HM_BAG" and not toolkitOwns(id) then
        return show("That item isn't in\nthe TOOLKIT.")
      end
      mod.save:set("registered_key_item_v1", id)
      local label = id == TOOLKIT_ID and "TOOLKIT" or (KEY_LABEL[id] or id)
      show(vpFormatDialogue(label .. " was registered!\fPress SELECT in the overworld to use it.\fHold SELECT in the overworld to reopen REGISTER."))
    end

    local function openFieldTools()
      gameRef.stack:push(Menu.new(gameRef, {
        { label = "AXE", onSelect = useAxe },
        { label = "BALLOON", onSelect = useBalloon },
        { label = "SURFBOARD", onSelect = useSurfboard },
        { label = "CROWBAR", onSelect = useCrowbar },
        { label = "FLASHLIGHT", onSelect = useFlashlight },
        { label = "CANCEL" },
      }, { tx = 2, ty = 1, tw = 16 }))
    end

    local function openFishingGear()
      consolidateOwnedKeyItems(gameRef)
      local rows = {}
      for _, id in ipairs(TOOLKIT_FISHING_ITEMS) do
        if toolkitOwns(id) and gameRef.save.inventory[id] then
          local itemId = id
          rows[#rows + 1] = { label = KEY_LABEL[itemId] or itemId,
            onSelect = function() useStoredKeyItem(itemId) end }
        end
      end
      if #rows == 0 then return show("No fishing gear is\nstored in the TOOLKIT.") end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16, maxVisible = 7 }))
    end

    local function openEquipment()
      consolidateOwnedKeyItems(gameRef)
      local rows = {}
      for _, id in ipairs(TOOLKIT_EQUIPMENT_ITEMS) do
        if toolkitOwns(id) and gameRef.save.inventory[id] then
          local itemId = id
          rows[#rows + 1] = { label = KEY_LABEL[itemId] or itemId,
            onSelect = function() useStoredKeyItem(itemId) end }
        end
      end
      if #rows == 0 then return show("No equipment is\nstored in the TOOLKIT.") end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16, maxVisible = 7 }))
    end

    local function openKeysBox()
      consolidateOwnedKeyItems(gameRef)
      local rows = {}
      for _, id in ipairs(TOOLKIT_KEY_ITEMS) do
        if gameRef.save.inventory[id] and gameRef.save.inventory[id] > 0 then
          local itemId = id
          rows[#rows + 1] = { label = KEY_LABEL[itemId] or itemId, keepOpen = true,
            onSelect = function()
              show((KEY_LABEL[itemId] or itemId) .. " is stored\nin the KEYS BOX.")
            end }
        end
      end
      if #rows == 0 then return show("No keys or passes are\nstored in the KEYS BOX.") end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16, maxVisible = 7 }))
    end

    local TOOLKIT_TM_MOVES = {
      "MEGA PUNCH","RAZOR WIND","SWORDS DANCE","WHIRLWIND","MEGA KICK",
      "TOXIC","HORN DRILL","BODY SLAM","TAKE DOWN","DOUBLE-EDGE",
      "BUBBLEBEAM","WATER GUN","ICE BEAM","BLIZZARD","HYPER BEAM",
      "PAY DAY","SUBMISSION","COUNTER","SEISMIC TOSS","RAGE",
      "MEGA DRAIN","SOLARBEAM","DRAGON RAGE","THUNDERBOLT","THUNDER",
      "EARTHQUAKE","FISSURE","DIG","PSYCHIC","TELEPORT",
      "MIMIC","DOUBLE TEAM","REFLECT","BIDE","METRONOME",
      "SELFDESTRUCT","EGG BOMB","FIRE BLAST","SWIFT","SKULL BASH",
      "SOFTBOILED","DREAM EATER","SKY ATTACK","REST","THUNDER WAVE",
      "PSYWAVE","EXPLOSION","ROCK SLIDE","TRI ATTACK","SUBSTITUTE",
    }
    local TOOLKIT_TM_NUMBER = {}
    local function toolkitMachineKey(v)
      return tostring(v or ""):upper():gsub("[^A-Z0-9]", "")
    end
    for n, name in ipairs(TOOLKIT_TM_MOVES) do TOOLKIT_TM_NUMBER[toolkitMachineKey(name)] = n end
    local TOOLKIT_HM_NUMBER = { CUT = 1, FLY = 2, SURF = 3, STRENGTH = 4, FLASH = 5 }

    local openingToolkitMachineBag = false

    -- Vanilla+ SELECT bridge (test16).
    -- Uses the same fixed-step queue pattern as the current Quick Select mod.
    local vpTMHMBagActive = false
    local vpTMHMSortNow = nil

    local function machineMeta(id)
      local def = gameRef and gameRef.data and gameRef.data.items and gameRef.data.items[id]
      local moveId = def and def.machine and def.machine.move
      local move = moveId and gameRef.data.moves and gameRef.data.moves[moveId]
      local moveName = (move and move.name) or tostring(moveId or id):gsub("_", " ")
      local key = toolkitMachineKey(moveName)
      local kind = def and def.machine and def.machine.kind or "TM"
      local num = kind == "HM" and TOOLKIT_HM_NUMBER[key] or TOOLKIT_TM_NUMBER[key]
      return { id = id, kind = kind, num = num or 999, move = moveName,
        type = tostring((move and move.type) or "UNKNOWN") }
    end

    local function sortMachineRows(rows, mode)
      -- CANCEL is the Bag terminator, not a machine. Recomp 0.2.56 exposes it
      -- as a real selectable row, so never feed it through the TM sorter.
      local machines, cancelRows = {}, {}
      for _, row in ipairs(rows or {}) do
        if row and row.cancel then cancelRows[#cancelRows + 1] = row
        else machines[#machines + 1] = row end
      end
      table.sort(machines, function(a, b)
        local ma, mb = machineMeta(a.value), machineMeta(b.value)
        if mode == "ALPHA" then
          if ma.move ~= mb.move then return ma.move < mb.move end
        elseif mode == "TYPE" then
          if ma.type ~= mb.type then return ma.type < mb.type end
          if ma.move ~= mb.move then return ma.move < mb.move end
        else
          if ma.kind ~= mb.kind then return ma.kind == "TM" end
          if ma.num ~= mb.num then return ma.num < mb.num end
        end
        return ma.id < mb.id
      end)
      for i = #rows, 1, -1 do rows[i] = nil end
      for _, row in ipairs(machines) do rows[#rows + 1] = row end
      for _, row in ipairs(cancelRows) do rows[#rows + 1] = row end
    end

    openTMHMBag = function()
      local g = gameRef
      if not (g and g.save and g.data) then return end
      consolidateOwnedKeyItems(g)
      local hasMachine = false
      for id, qty in pairs(g.save.inventory or {}) do
        if qty > 0 and isMachineItem(g, id) then hasMachine = true break end
      end
      if not hasMachine then return show("No TMs or HMs are\nin the TM/HM BAG.") end

      -- Imported-save safety (test84): never remove real inventory entries just
      -- to build this screen. Raw .sav imports do not preserve Vanilla+ modData,
      -- so a UI interruption while inventory was temporarily hidden could make
      -- legitimate items appear lost. Keep the save authoritative and filter
      -- only the visible BagMenu rows instead.
      openingToolkitMachineBag = true
      local BagMenu = require("src.ui.BagMenu")
      local list = BagMenu.new(g, {})
      openingToolkitMachineBag = false

      vpTMHMBagActive = true
      local previousClose = list.close
      function list:close(...)
        vpTMHMBagActive = false
        vpTMHMSortNow = nil
        return previousClose(self, ...)
      end
      local previousCancel = list.onCancel
      list.onCancel = function(...)
        vpTMHMBagActive = false
        vpTMHMSortNow = nil
        if previousCancel then return previousCancel(...) end
      end

      local modes = { "NUM", "ALPHA", "TYPE" }
      local mode = mod.save:get("toolkit_tm_sort_v1") or "NUM"
      local function normalizeMode()
        for _, m in ipairs(modes) do if mode == m then return end end
        mode = "NUM"
      end
      normalizeMode()

      local function filterAndSortMachineRows()
        if type(list.items) ~= "table" then return end
        local selected = list.items[list.index] and list.items[list.index].value
        local filtered = {}
        local cancelRow = nil
        for _, row in ipairs(list.items) do
          local id = row and row.value
          if row and row.cancel then
            cancelRow = cancelRow or row
          elseif id and isMachineItem(g, id) then
            filtered[#filtered + 1] = row
          end
        end
        if cancelRow then filtered[#filtered + 1] = cancelRow end
        list.items = filtered
        sortMachineRows(list.items, mode) -- helper always re-appends CANCEL last
        if selected then
          for i, row in ipairs(list.items) do
            if row.value == selected then list.index = i break end
          end
        end
        list.index = math.max(1, math.min(list.index or 1, math.max(1, #list.items)))
        list.title = "TM/HM BAG"
        -- Six item rows leave the seventh interior line as a dedicated status
        -- slot. This keeps SELECT: SORT clear of the bottom frame on 0.2.56.
        list.rows = 6
        list.footer = "SELECT: SORT " .. mode
      end

      local function cycleSortMode()
        local idx = 1
        for i, m in ipairs(modes) do if m == mode then idx = i break end end
        mode = modes[(idx % #modes) + 1]
        mod.save:set("toolkit_tm_sort_v1", mode)
        filterAndSortMachineRows()
      end
      list.onSelectKey = function(_, l) cycleSortMode() end
      vpTMHMSortNow = cycleSortMode
      local previousUpdate = list.update
      function list:update(dt)
        local result = previousUpdate(self, dt)
        -- Native BagMenu may rebuild rows after teaching/using a machine.
        -- Re-filter after the refresh without ever touching save.inventory.
        filterAndSortMachineRows()
        return result
      end
      filterAndSortMachineRows()
      g.stack:push(list)
    end

    local function openRegisterMenu()
      local rows = {
        { label = "TOOLKIT", onSelect = function() registerKeyItem(TOOLKIT_ID) end },
        { label = "LAPTOP", onSelect = function() registerKeyItem(LAPTOP_ID) end },
        { label = "TM/HM BAG", onSelect = function() registerKeyItem("TM_HM_BAG") end },
      }
      for _, group in ipairs({ TOOLKIT_FISHING_ITEMS, TOOLKIT_EQUIPMENT_ITEMS }) do
        for _, id in ipairs(group) do
          if toolkitOwns(id) and gameRef.save.inventory[id] then
            local itemId = id
            rows[#rows + 1] = { label = KEY_LABEL[itemId] or itemId,
              onSelect = function() registerKeyItem(itemId) end }
          end
        end
      end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16, maxVisible = 6 }))
    end


    openToolkit = function()
      if not gameRef then return end
      consolidateOwnedKeyItems(gameRef)
      local toolkitMenu = Menu.new(gameRef, {
        { label = "FIELD TOOLS", onSelect = openFieldTools },
        { label = "LAPTOP", onSelect = function() useStoredKeyItem(LAPTOP_ID) end },
        { label = "FISHING", onSelect = openFishingGear },
        { label = "TM/HM BAG", onSelect = openTMHMBag },
        { label = "EQUIPMENT", onSelect = openEquipment },
        { label = "KEYS & TICKETS", onSelect = openKeysBox },
        { label = "REGISTER", onSelect = openRegisterMenu },
        { label = "CANCEL" },
      }, { tx = 2, ty = 0, tw = 16, th = 18 })

      -- Gen I's stock tile font has no ampersand glyph, so Font.draw leaves
      -- the '&' cell blank. Keep the intended label and draw a tiny matching
      -- pixel ampersand into that one cell rather than renaming the menu row.
      local previousToolkitDraw = toolkitMenu.draw
      function toolkitMenu:draw(...)
        previousToolkitDraw(self, ...)
        local visible = #self.items
        local row = 6 -- KEYS & TICKETS
        local x = (self.tx + 2 + 5) * 8
        local y = (self.ty + self.th - 2 - (visible - row) * self.rowStep) * 8
        local pixels = {
          {1,0},{2,0},
          {0,1},{3,1},
          {0,2},{2,2},
          {1,3},{2,3},
          {0,4},{2,4},{4,4},
          {0,5},{3,5},
          {1,6},{2,6},{4,6},
        }
        love.graphics.setColor(0, 0, 0, 1)
        for _, px in ipairs(pixels) do
          love.graphics.rectangle("fill", x + px[1], y + px[2], 1, 1)
        end
        love.graphics.setColor(1, 1, 1, 1)
      end
      gameRef.stack:push(toolkitMenu)
    end

    -- Once owned, the Toolkit participates in normal A-button context actions
    -- instead of requiring the player to reopen the Bag for every obstacle.
    mod.events:on("world.interacted", function(ev)
      if not (mod.options:get("adventurers_toolkit")
        and mod.save:get("toolkit_received_v1") and ev) then return end
      local ow = gameRef and gameRef.overworld
      if not (ow and ow.player and ow.map and ow.map.id == ev.mapId) then return end

      if ev.kind == "npc" and ev.target and ev.target.def then
        local okMap, Map = pcall(require, "src.world.Map")
        if okMap and Map and Map.isPushable and Map.isPushable(ev.target.def) then
          -- The vanilla boulder interaction may already have pushed its
          -- "requires STRENGTH" box before world.interacted reaches mods.
          -- Replace that box with the Toolkit choice instead of stacking both.
          local top = gameRef.stack and gameRef.stack:top()
          if top and top ~= ow then gameRef.stack:pop() end
          gameRef.stack:push(ActionChoice.new(gameRef, {
            { label = "CROWBAR", action = useCrowbar },
            { label = "CANCEL" },
          }))
        end
        return
      end
      if ev.kind ~= "none" then return end

      local fx, fy = ev.x, ev.y
      if not ow.map:inBounds(fx, fy) then return end
      local ts = ow.map.def.tileset
      local tile = ow.map:cellTile(fx, fy)
      local isGrass = (ts == "OVERWORLD" and tile == 0x52)
      local isTree = (ts == "OVERWORLD" and tile == 0x3d)
        or (ts == "GYM" and tile == 0x50)
      if isTree or isGrass then
        gameRef.stack:push(ActionChoice.new(gameRef, {
          { label = "AXE", action = useAxe },
          { label = "CANCEL" },
        }))
        return
      end

      -- Same protection as the normal field-shortcut handler: raw water
      -- tile IDs are reused by furniture/indoor tiles. Require the map's
      -- tileset to be one the engine recognizes as water-capable first.
      local waterTileset = ow.tilesetHasWater and ow:tilesetHasWater() or false
      if waterTileset and ow.map:isWaterCell(fx, fy) then
        local entries = { { label = "SURFBOARD", action = useSurfboard } }
        local rods = {}
        for _, id in ipairs({ "OLD_ROD", "GOOD_ROD", "SUPER_ROD" }) do
          if toolkitOwns(id) then rods[#rods + 1] = id end
        end
        if #rods == 1 then
          local rod = rods[1]
          entries[#entries + 1] = { label = KEY_LABEL[rod], action = function() ow:goFishing(rod) end }
        elseif #rods > 1 then
          for _, id in ipairs(rods) do
            local rod = id
            entries[#entries + 1] = { label = KEY_LABEL[rod], action = function() ow:goFishing(rod) end }
          end
        end
        entries[#entries + 1] = { label = "CANCEL" }
        gameRef.stack:push(ActionChoice.new(gameRef, entries))
      end
    end)

    -- A real one-slot key item in the normal bag. Its USE opens the separate
    -- five-tool page; it is never consumed.
    mod.events:on("game.ready", function(ev)
      local g = ev and ev.game
      if not g then return end
      g.data.items[TOOLKIT_ID] = g.data.items[TOOLKIT_ID] or {
        id = TOOLKIT_ID, name = TOOLKIT_NAME, price = 0,
        keyItem = true, pocket = "KEY_ITEM",
      }
      restorePortableTransferRecord(g)
      -- Self-heal nonstandard acquisition (cheats, save editors, another mod,
      -- or an older migration): actual Toolkit ownership is enough.
      if toolkitItemOwned(g) and not mod.save:get("toolkit_received_v1") then
        mod.save:set("toolkit_received_v1", true)
      end
      if toolkitUnlocked(g) then
        consolidateOwnedKeyItems(g)
        if not mod.save:get("registered_key_item_v1") then
          mod.save:set("registered_key_item_v1", TOOLKIT_ID)
        end
      end
    end)

    -- Recomp 0.2.56 full-height Bag compatibility -----------------------
    -- Vanilla+ intentionally presents Bag/TM-HM lists as full pages. The
    -- current native Bag uses itemBox=true; forcing only itemBox=false drops
    -- `item.count` because generic ListMenu rows render `right` but not count.
    -- Keep the full-height presentation, but give kind=bag its own thin renderer
    -- that honors current row fields, keeps CANCEL selectable, and restores a
    -- Gen-I frame around the page. PC item lists remain completely native.
    do
      local okListMenu, ListMenu = pcall(require, "src.ui.ListMenu")
      local okFont, Font = pcall(require, "src.render.Font")
      local okTheme, Theme = pcall(require, "src.ui.Theme")
      local okStrings, Strings = pcall(require, "src.core.Strings")
      if okListMenu and okFont and okTheme and okStrings and ListMenu
        and not ListMenu._vanillaPlusFullBagRecomp0256 then
        ListMenu._vanillaPlusFullBagRecomp0256 = true
        local previousListNew = ListMenu.new
        local previousListDraw = ListMenu.draw
        function ListMenu.new(g, title, items, opts)
          if opts and opts.kind == "bag" then
            local copy = {}
            for k, v in pairs(opts) do copy[k] = v end
            copy.itemBox = false
            copy.rows = 7
            opts = copy
          end
          return previousListNew(g, title, items, opts)
        end

        function ListMenu:draw()
          if self.kind ~= "bag" or self.itemBox then
            return previousListDraw(self)
          end
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.rectangle("fill", 0, 0, 160, 144)
          Font.drawBox(0, 0, 20, 18)
          love.graphics.setColor(0, 0, 0, 1)

          local title = Strings(self.title or "ITEMS")
          Font.draw(title, 16, 8)
          if self.footer then
            local hint = tostring(self.footer)
            if tostring(self.title or "") == "TM/HM BAG" then
              -- Dedicated status slot above the bottom border. TM/HM Bag uses
              -- six item rows, so y=128 is clear and never touches the frame.
              Font.draw(hint, 152 - Font.width(hint), 128)
            else
              Font.draw(hint, 152 - Font.width(hint), 8)
            end
          end
          if #self.items == 0 then Font.draw(Strings("Nothing here."), 16, 32) end

          local shown, sawCancel = 0, false
          for row = 1, (self.rows or 7) do
            local i = (self.scroll or 0) + row
            local item = self.items[i]
            if not item then break end
            shown = shown + 1
            if item.cancel then sawCancel = true end
            local y = 8 + row * 16
            local rhs = nil
            if item.count ~= nil then rhs = "x" .. tostring(item.count)
            elseif item.right ~= nil then rhs = tostring(item.right)
            elseif item.sub ~= nil then rhs = tostring(item.sub) end
            local budget = 136
            if rhs then budget = 136 - Font.width(rhs) - 8 end
            local label = tostring(item.label or "")
            -- Bag item names are short enough for the current 17-column page,
            -- but trim defensively if another mod supplies a long custom item.
            while Font.width(label) > budget and #label > 1 do label = label:sub(1, -2) end
            Font.draw(label, 16, y)
            if rhs then Font.draw(rhs, 144 - Font.width(rhs), y) end
            if i == self.index then
              Font.drawCode(self.hollowIndex == i and Theme.cursorHollow or Theme.cursor, 8, y)
            end
            if self.swapIndex == i and i ~= self.index then
              Font.drawCode(Theme.cursorHollow, 8, y)
            end
          end
          if shown == (self.rows or 7) and not sawCancel then
            local moreY = tostring(self.title or "") == "TM/HM BAG" and 112 or 128
            Font.drawCode(Theme.moreArrow, 144, moreY)
          end
          love.graphics.setColor(1, 1, 1, 1)
        end
      end
    end

    -- Hide consolidated equipment from the normal Bag and Player PC while
    -- leaving its ownership mirrored in save.inventory for vanilla scripts.
    do
      local okBagMenu, BagMenu = pcall(require, "src.ui.BagMenu")
      if okBagMenu and BagMenu and not BagMenu._vanillaPlusToolkitConsolidationWrapped then
        BagMenu._vanillaPlusToolkitConsolidationWrapped = true
        local previousBagNew = BagMenu.new
        function BagMenu.new(g, opts)
          if openingToolkitMachineBag then return previousBagNew(g, opts) end
          -- Imported-save safety: construct the native Bag from the untouched
          -- inventory and hide Toolkit-managed rows only in the menu model.
          -- Never delete/restore save.inventory entries as a presentation hack.
          local list = previousBagNew(g, opts)

          -- BagMenu can rebuild its visible rows from the live inventory after
          -- actions such as TOSS. Re-filter the already-open Bag after every
          -- update so Toolkit-managed items never leak back into view.
          if list and not list._vanillaPlusToolkitLiveFilter then
            list._vanillaPlusToolkitLiveFilter = true

            local function filterToolkitRows()
              if not toolkitUnlocked(g) or type(list.items) ~= "table" then return end
              local filtered = {}
              for _, row in ipairs(list.items) do
                local id = row and row.value
                if not (id and toolkitStoredItem(g, id)) then
                  filtered[#filtered + 1] = row
                end
              end
              list.items = filtered
              local count = #filtered
              if count == 0 then
                list.index = 1
              elseif (list.index or 1) > count then
                list.index = count
              elseif (list.index or 1) < 1 then
                list.index = 1
              end
            end

            filterToolkitRows()

            local previousUpdate = list.update
            function list:update(...)
              local result = previousUpdate(self, ...)
              filterToolkitRows()
              return result
            end
          end

          return list
        end
      end
      local okPlayerPC, PlayerPC = pcall(require, "src.ui.PlayerPC")
      if okPlayerPC and PlayerPC and not PlayerPC._vanillaPlusToolkitConsolidationWrapped then
        PlayerPC._vanillaPlusToolkitConsolidationWrapped = true
        local previousPCNew = PlayerPC.new
        function PlayerPC.new(g, opts)
          if not toolkitUnlocked(g) then return previousPCNew(g, opts) end
          -- Keep the real vanilla items mirrored for scripts, but make them
          -- non-depositable by temporarily hiding them for the lifetime of
          -- each DEPOSIT list construction. PlayerPC's submenu is created
          -- after this root menu, so intercept ListMenu.new by its semantic kind.
          local ListMenu = require("src.ui.ListMenu")
          if not ListMenu._vanillaPlusToolkitDepositWrapped then
            ListMenu._vanillaPlusToolkitDepositWrapped = true
            local prevListNew = ListMenu.new
            function ListMenu.new(game, title, items, listOpts)
              if listOpts and listOpts.kind == "pc_item_deposit"
                and mod.save:get("toolkit_received_v1") then
                local filtered = {}
                for _, item in ipairs(items or {}) do
                  local id = item and item.value
                  if not (id and toolkitStoredItem(game, id)) then filtered[#filtered + 1] = item end
                end
                items = filtered
              end
              return prevListNew(game, title, items, listOpts)
            end
          end
          return previousPCNew(g, opts)
        end
      end
      if not Bag._vanillaPlusToolkitSlotsWrapped then
        Bag._vanillaPlusToolkitSlotsWrapped = true
        local previousSlots = Bag.slots
        function Bag.slots(save, data, pocket)
          local n = previousSlots(save, data, pocket)
          if mod.save:get("toolkit_received_v1") and save and save.inventory then
            for id in pairs(save.inventory) do
              local g = gameRef
              if toolkitStoredItem(g, id)
                and (not pocket or Bag.pocketOf(id, data) == pocket) then
                n = math.max(0, n - 1)
              end
            end
          end
          return n
        end
      end
    end

    -- TM move-name labels ---------------------------------------------------
    local tmMoves = {
      "MEGA PUNCH","RAZOR WIND","SWORDS DANCE","WHIRLWIND","MEGA KICK",
      "TOXIC","HORN DRILL","BODY SLAM","TAKE DOWN","DOUBLE-EDGE",
      "BUBBLEBEAM","WATER GUN","ICE BEAM","BLIZZARD","HYPER BEAM",
      "PAY DAY","SUBMISSION","COUNTER","SEISMIC TOSS","RAGE",
      "MEGA DRAIN","SOLARBEAM","DRAGON RAGE","THUNDERBOLT","THUNDER",
      "EARTHQUAKE","FISSURE","DIG","PSYCHIC","TELEPORT",
      "MIMIC","DOUBLE TEAM","REFLECT","BIDE","METRONOME",
      "SELFDESTRUCT","EGG BOMB","FIRE BLAST","SWIFT","SKULL BASH",
      "SOFTBOILED","DREAM EATER","SKY ATTACK","REST","THUNDER WAVE",
      "PSYWAVE","EXPLOSION","ROCK SLIDE","TRI ATTACK","SUBSTITUTE",
    }
    local originalTMNames = {}

    local function applyTMNames()
      -- Superseded by the data-driven machine-label repair installed below.
      -- Kept as a no-op because older save/event plumbing still calls it.
    end

    mod.events:on("game.ready", function() applyTMNames() end)
    mod.events:on("mod.options_changed", function(ev)
      if ev and ev.key == "tm_move_names" then applyTMNames() end
    end)

    if not ItemEffects._vanillaPlusToolkitWrapped then
      ItemEffects._vanillaPlusToolkitWrapped = true
      local originalUse = ItemEffects.use
      function ItemEffects.use(data, save, itemId, target, battle, moveIndex, ow)
        if itemId == TOOLKIT_ID then
          if battle then
            return "failed", { "OAK: " .. (save.player.name or "RED")
              .. "!\nThis isn't the\ntime to use that!" }
          end
          openToolkit()
          return "kept", nil
        end
        local result, payload, extra = originalUse(data, save, itemId, target, battle, moveIndex, ow)
        local def = data and data.items and data.items[itemId]
        if mod.options:get("reusable_tms") and result == "learn"
          and def and def.machine and def.machine.kind == "TM" then
          result = "learnkept"
        end
        return result, payload, extra
      end
    end

    mod.events:on("map.entered", function()
      if mod.save:get("toolkit_received_v1") then consolidateOwnedKeyItems(gameRef) end
    end)

    -- Registered Toolkit shortcuts: test16 uses the proven Quick Select
    -- fixed-step input pattern and invokes actions directly from input.step.
    do
      local armed, holdFrames, holdUsed = false, 0, false

      local function queued(input, button)
        for _, value in ipairs((input and input.pressQueue) or {}) do
          if value == button then return true end
        end
        return false
      end

      local function consumeQueued(input, button)
        if not input or type(input.pressQueue) ~= "table" then return end
        local kept = {}
        for _, value in ipairs(input.pressQueue) do
          if value ~= button then kept[#kept + 1] = value end
        end
        input.pressQueue = kept
      end

      local function freeRoam(g)
        local ow = g and g.overworld
        local p = ow and ow.player
        if not ow or not p or not g.stack or g.stack:top() ~= ow
          or g.linkSession or (g.linkNet and not g.linkNet.closed)
          or p.moving or p.inputLocked or ow.transitioning or ow.engaging
          or ow.emote or ow.teleportOut or ow.flyAnim or ow.healAnim
          or ow.pikaHop or ow.cutAnim or ow.dustAnim or ow.fishPose
          or p.spinning or p.fishing or #((ow.scriptMoves) or {}) > 0 then
          return false
        end
        if ow.runner and ow.runner.isRunning and ow.runner:isRunning() then return false end
        return true
      end

      mod.hooks:wrap("input.step", function(nextFn, g, dt)
        -- Exact important ordering used by Quick Select: sibling hooks first.
        if nextFn then nextFn(g, dt) end
        local input = g and g.input
        if not input or not toolkitUnlocked(g) then
          armed, holdFrames, holdUsed = false, 0, false
          return
        end

        local selectPressed = queued(input, "select")
        local selectDown = input.state and input.state.select == true

        if vpTMHMBagActive then
          if selectPressed and vpTMHMSortNow then
            consumeQueued(input, "select")
            vpTMHMSortNow()
          end
          return
        end

        if not freeRoam(g) then
          if not selectDown then armed, holdFrames, holdUsed = false, 0, false end
          return
        end

        if selectPressed then
          armed, holdFrames, holdUsed = true, 0, false
          consumeQueued(input, "select")
          if not selectDown then
            armed = false
            local id = mod.save:get("registered_key_item_v1")
            if id then useStoredKeyItem(id) end
            return
          end
        end

        if not armed then return end
        if selectDown then
          holdFrames = holdFrames + 1
          if holdFrames >= 24 and not holdUsed then
            holdUsed, armed = true, false
            openRegisterMenu()
            return
          end
        else
          armed = false
          if not holdUsed then
            local id = mod.save:get("registered_key_item_v1")
            if id then useStoredKeyItem(id) end
          end
          holdFrames, holdUsed = 0, false
        end
      end, 500)
    end

    -- Post-Champion Toolkit handoff.  Nothing fires automatically anymore.
    -- The first Nurse Joy the Champion speaks to gives a one-time breadcrumb,
    -- then the real handoff waits for RED to return home and talk to Mom.
    local function toolkitChampionReady()
      local g = gameRef
      return mod.options:get("adventurers_toolkit")
        and not mod.save:get("toolkit_received_v1")
        and g and g.save and g.save.flags
        and g.save.flags.EVENT_BEAT_CHAMPION_RIVAL
    end

    local function isNurseNPC(npc)
      local name = tostring(npc and npc.def and npc.def.name or ""):upper()
      local spr = tostring(npc and npc.def and npc.def.sprite or ""):upper()
      return name:find("NURSE", 1, true) ~= nil or spr:find("NURSE", 1, true) ~= nil
    end

    local function isMomNPC(ow, npc)
      if not (ow and ow.map and ow.map.id == "REDS_HOUSE_1F" and npc) then return false end
      local name = tostring(npc.def and npc.def.name or ""):upper()
      if name:find("MOM", 1, true) then return true end
      -- Gen I's downstairs house normally contains only Mom.  Some data packs
      -- do not preserve her friendly NPC name, so allow the first native NPC as
      -- a compatibility fallback instead of requiring a custom spawned Mom.
      return ow.npcs and ow.npcs[1] == npc and not npc.vpMimey
    end

    local function giveToolkitFromMom(ow, mom)
      local g = gameRef
      if not (g and ow and mom) then return end
      mom:facePlayer(ow.player)
      local packedReturn = mod.save:get("toolkit_transfer_packed_v1") == true

      local function finishGive()
        local added = Bag.add(g.save, TOOLKIT_ID, 1, g.data)
        if not added then
          return show(vpFormatDialogue("MOM: Your BAG is full! Make some room and come talk to me again."))
        end
        mod.save:set("toolkit_received_v1", true)
        mod.save:set("toolkit_ever_received_v1", true)
        mod.save:set("toolkit_transfer_packed_v1", false)
        consolidateOwnedKeyItems(g)
        mod.save:set("registered_key_item_v1", TOOLKIT_ID)

        if packedReturn then
          show(vpFormatDialogue("MOM: There we go! I put your TOOLKIT back together and organized everything again."), function()
            show(vpFormatDialogue(playerName() .. " received the ADVENTURER'S TOOLKIT! Press SELECT in the overworld to use it. Hold SELECT to reopen REGISTER."))
          end)
        else
          show(vpFormatDialogue("MOM: I organized your adventure gear while you were away. I even checked your PC and put your key gear into the TOOLKIT. I bought you a few extra things too... and this fancy new thing called a LAPTOP!"), function()
            show(vpFormatDialogue(playerName() .. " received the ADVENTURER'S TOOLKIT! Press SELECT in the overworld to use it. Hold SELECT to reopen REGISTER."))
          end)
        end
      end

      if packedReturn then
        show(vpFormatDialogue("MOM: Back already? I can put your TOOLKIT together again now that your save is settled. Want me to rebuild it?"), function()
          local Menu = require("src.ui.Menu")
          gameRef.stack:push(Menu.new(gameRef, {
            { label = "YES", onSelect = finishGive },
            { label = "NO", onSelect = function()
                show(vpFormatDialogue("MOM: No problem. Your gear will stay packed until you're ready."))
              end },
          }, { tx = 12, ty = 7, tw = 8, th = 6 }))
        end)
      else
        show(vpFormatDialogue("MOM: " .. playerName() .. "! There you are. Nurse Joy said you might stop by. You've traveled all over KANTO now, so I put together something useful for your adventures."), finishGive)
      end
    end

    if not OverworldState._vanillaPlusMomToolkitTalkWrapped then
      OverworldState._vanillaPlusMomToolkitTalkWrapped = true
      local previousTalkTo = OverworldState.talkTo
      function OverworldState:talkTo(npc)
        if npc and isMomNPC(self, npc) and mod.save:get("toolkit_received_v1") then
          npc:facePlayer(self.player)
          local Menu = require("src.ui.Menu")
          local state = self
          local momExtraLines = {
            "MOM: It's nice having you home, even if you never stay put for very long.",
            "MOM: MR.MIME has certainly made himself comfortable around here. He acts like he owns the place sometimes!",
            "MOM: PROF.OAK still asks about you. I think he's proud, even when he tries to sound like a professor about it.",
            "MOM: You've seen more of KANTO than most people ever will. Just remember PALLET TOWN is still home.",
            "MOM: I keep hearing stories about the CHAMPION. Funny, they never mention how messy your room used to be!",
            "MOM: Your adventures keep getting stranger. I stopped being surprised a long time ago.",
          }
          local function momTalk()
            if not mod.options:get("oak_postdex_life") then
              return show(vpFormatDialogue("MOM: It's good to see you, " .. playerName() .. "."))
            end
            local last = tonumber(mod.save:get("mom_extra_dialogue_last_v1")) or 0
            local pick = math.random(#momExtraLines)
            if #momExtraLines > 1 and pick == last then pick = (pick % #momExtraLines) + 1 end
            mod.save:set("mom_extra_dialogue_last_v1", pick)
            show(vpFormatDialogue(momExtraLines[pick]))
          end
          show(vpFormatDialogue("MOM: Need anything?"), function()
            gameRef.stack:push(Menu.new(gameRef, {
              { label = "TALK", onSelect = momTalk },
              -- Preserve the native Mom interaction as the explicit HEAL path.
              { label = "HEAL", onSelect = function() previousTalkTo(state, npc) end },
              { label = "PACK TOOLKIT", onSelect = function()
                  local ok, msg = packToolkitForTransfer(gameRef)
                  if ok then
                    show(vpFormatDialogue("MOM: All packed! " .. msg .. " SAVE the game before exporting or moving the save. When you're settled, come back and I'll put the TOOLKIT together again."))
                  else
                    show(vpFormatDialogue("MOM: I couldn't pack it yet. " .. tostring(msg)))
                  end
                end },
              { label = "CANCEL" },
            }, { tx = 3, ty = 3, tw = 14, th = 10 }))
          end)
          return
        end

        if toolkitChampionReady() and npc then
          local mapId = tostring(self.map and self.map.id or ""):upper()
          if mapId:find("POKECENTER", 1, true)
            and isNurseNPC(npc)
            and not mod.save:get("toolkit_mom_hint_v1") then
            mod.save:set("toolkit_mom_hint_v1", true)
            local state = self
            show(vpFormatDialogue("NURSE JOY: RED! Your mother was looking for you. You should stop by home when you get a chance."), function()
              previousTalkTo(state, npc)
            end)
            return
          end

          if isMomNPC(self, npc) then
            giveToolkitFromMom(self, npc)
            return
          end
        end
        return previousTalkTo(self, npc)
      end
    end

    -- Mimey: post-Champion household life. He roams the whole downstairs
    -- instead of hovering beside Mom. His timer is intentionally aggressive so
    -- the player may genuinely have to chase him down to talk.
    local function randomMimeCell(ow)
      local Collision = require("src.world.Collision")
      local w, h = ow.map.widthCells or 0, ow.map.heightCells or 0
      if w <= 0 or h <= 0 then return nearbyFreeCell(ow, 5, 4) end
      for _ = 1, 80 do
        local x = love.math.random(0, math.max(0, w - 1))
        local y = love.math.random(0, math.max(0, h - 1))
        if ow.map:inBounds(x, y) and ow.map:isWalkableCell(x, y)
          and not ow.map:warpAtCell(x, y)
          and not Collision.occupied(ow.entities, x, y, nil) then
          return x, y
        end
      end
      return nearbyFreeCell(ow, 5, 4)
    end

    local function maybeSpawnMimey()
      local g, ow = gameRef, gameRef and gameRef.overworld
      if not (g and ow and ow.map and ow.map.id == "REDS_HOUSE_1F") then return end
      removeTagged(ow, "vpMimey")
      if not mod.options:get("postgame_mimey")
        or not (g.save.flags and g.save.flags.EVENT_BEAT_CHAMPION_RIVAL) then return end
      local sprite = g.data.sprites.SPRITE_MONSTER and "SPRITE_MONSTER"
      if not sprite then return end
      local x, y = randomMimeCell(ow)
      if not x then x, y = nearbyFreeCell(ow, ow.player.cellX, ow.player.cellY) end
      if not x then return end
      local mime = addRuntimeNPC(ow, "vpMimey", sprite, x, y, "WALK")
      if mime then
        mime.species = "MR_MIME"
        mime.enhancedDexId = "MR_MIME"
        mime.timer = 1
        local nativeUpdate = mime.update
        function mime:update(map, entities)
          local result = nativeUpdate(self, map, entities)
          -- Native WALK NPCs can idle 30-180 frames and sometimes only turn.
          -- Mimey is deliberately busier: cap every idle at a few frames so he
          -- continuously wanders across every reachable part of the house.
          if not self.moving and not self.frozen then
            self.timer = math.min(tonumber(self.timer) or 1, love.math.random(3, 10))
          end
          return result
        end
      end
    end

    if not OverworldState._vanillaPlusMimeTalkWrapped then
      OverworldState._vanillaPlusMimeTalkWrapped = true
      local previousTalkTo = OverworldState.talkTo
      local mimeLines = {
        "MR.MIME carefully sweeps one corner of the room, then admires his work with a proud little nod.",
        "MR.MIME wipes down the table with astonishing concentration. He notices you watching and gives a tiny bow.",
        "MR.MIME pauses and silently presses both palms against an invisible wall. It feels strangely convincing.",
        "MR.MIME spots you and waves both hands excitedly. Mime! Mime!",
        "MR.MIME practices an elaborate routine for an audience only he can see. He seems pleased when you applaud.",
        "MR.MIME points toward the television, shrugs dramatically, and begins acting out what he thinks should happen next.",
        "MR.MIME studies you for a moment, then perfectly imitates the way you were standing. He looks extremely proud.",
        "MR.MIME traces a square in the air and taps on an invisible window. Whatever he sees through it surprises him.",
        "MR.MIME gives you a cheerful salute. He seems genuinely happy whenever you come home.",
        "MR.MIME pretends to pull on an impossibly heavy rope. After a heroic struggle, he lets go and acts innocent.",
        "MR.MIME freezes when you look at him, then resumes his routine the instant you turn away.",
        "MR.MIME marches across the room with exaggerated importance, stops, and bows as though he has reached a stage.",
        "MR.MIME balances on one foot and slowly feels around for an invisible railing. Apparently the stairs are wherever he says they are.",
        "MR.MIME pantomimes opening a tiny box, peers inside, and immediately slams the imaginary lid shut.",
        "MR.MIME notices your POKEMON and gives an enthusiastic round of silent applause.",
        "MR.MIME taps an invisible barrier twice, listens carefully, and nods as if the wall answered him.",
        "MR.MIME acts out an entire conversation by himself, switching sides every few seconds. He refuses to explain any of it.",
        "MR.MIME points at you, points at himself, then draws a huge circle in the air. Whatever that means, he seems delighted.",
      }
      local mimeDeck, mimeDeckPos = {}, 1
      local function refillMimeDeck()
        mimeDeck = {}
        for i = 1, #mimeLines do mimeDeck[i] = i end
        for i = #mimeDeck, 2, -1 do
          local j = love.math.random(i)
          mimeDeck[i], mimeDeck[j] = mimeDeck[j], mimeDeck[i]
        end
        mimeDeckPos = 1
      end
      local function nextMimeLine()
        if #mimeDeck ~= #mimeLines or mimeDeckPos > #mimeDeck then refillMimeDeck() end
        local idx = mimeDeck[mimeDeckPos]
        mimeDeckPos = mimeDeckPos + 1
        return mimeLines[idx]
      end
      function OverworldState:talkTo(npc)
        if npc and npc.vpMimey then
          npc:facePlayer(self.player)
          show(vpFormatDialogue(nextMimeLine()))
          return
        end
        return previousTalkTo(self, npc)
      end
    end

    mod.events:on("map.entered", function()
      maybeSpawnMimey()
      applyPermanentCuts()

      local ow = gameRef and gameRef.overworld
      if flashlightActive and ow and not flashlightRebaking then
        -- A real map transition ends the local beam.  A DIAG20 palette re-bake
        -- reloads the same map internally and must NOT be mistaken for a ladder.
        flashlightActive = false
        gameRef.save.flashLit = false
        gameRef.save.vpFlashDiag = false
      end
      if ow and not (ow.player and ow.player.surfing) then surfboardActive = false end
      if balloonActive and ow and not ow.flyAnim then balloonActive = false end
    end)

    -- HOTFIX4-DIAG17: player-anchor calibration inside the world pass.
    -- Do not alter cave palettes in this diagnostic. We leave Rock Tunnel in
    -- its native dark state and draw high-contrast markers in the known-good
    -- OverworldState.draw path so we can measure player/camera coordinates.

    -- Lightweight tool presentation. SURFBOARD and BALLOON keep the engine's
    -- proven movement/Fly systems underneath while adding distinct visual
    -- cues; flashlight is intentionally generous and cosmetic.
    if not OverworldState._vanillaPlusToolkitDrawWrapped then
      OverworldState._vanillaPlusToolkitDrawWrapped = true
      local originalDraw = OverworldState.draw
      function OverworldState:draw()
        originalDraw(self)
        local p, cam = self.player, self.camera
        if not (p and cam) then return end
        local px = math.floor(p.px - cam.x + 8)
        local py = math.floor(p.py - cam.y + 8)

        -- FLASHLIGHT uses Recomp's native FLASH lighting path.
        -- No custom palette or post-frame beam is installed in this build.

        -- HOTFIX4-DIAG17: outer-pass diagnostics intentionally removed.
        -- The real calibration marker now draws *inside* drawWorld, while the
        -- renderer is still in native world-canvas coordinates.
        -- HOTFIX4-DIAG10: darkness/lighting is handled in drawWorld below.
        -- Keep this outer draw wrapper only for the Toolkit's other cosmetic FX.


        if toolkitVisual.frames > 0 then
          toolkitVisual.frames = toolkitVisual.frames - 1
          love.graphics.setColor(0, 0, 0, 1)
          if toolkitVisual.kind == "AXE" then
            love.graphics.line(px + 6, py - 8, px + 13, py - 15)
            love.graphics.rectangle("fill", px + 10, py - 17, 7, 3)
          elseif toolkitVisual.kind == "CROWBAR" then
            love.graphics.line(px + 5, py - 9, px + 13, py - 17)
            love.graphics.line(px + 13, py - 17, px + 16, py - 14)
          end
        end
        love.graphics.setColor(1, 1, 1, 1)
      end
    end

    -- HOTFIX4-DIAG24: directional flashlight renderer removed.
    -- Toolkit FLASHLIGHT intentionally relies on native Recomp FLASH.

  end

  -- Recomp 2 / Dramatics compatibility ------------------------------------
  -- Do NOT globally wrap Font.draw here. Dramatics renders battle scenes in
  -- multiple passes and the old white text-backing shim gets replayed with
  -- those passes, producing huge translucent HUD rectangles in Voxel mode.
  -- Keep the option schema for save compatibility, but intentionally make the
  -- old private tester shim a no-op on this build.

  -- Battle EXP bar -------------------------------------------------------
  -- DIAG28: The old option survived long after its renderer disappeared.
  -- Draw a small Gen-II-style progress strip after the battle's own draw so
  -- the feature is real again without replacing battle logic.
  do
    local okGrowth, Growth = pcall(require, "src.pokemon.Growth")
    if okGrowth and Growth and mod.events then
      local wrappedBattles = setmetatable({}, { __mode = "k" })

      local function expRatio(battle)
        local mon = battle and battle.player and battle.player.mon
        local def = mon and battle.data and battle.data.pokemon and battle.data.pokemon[mon.species]
        if not mon or not def then return nil end
        local cap = (battle.data.constants and battle.data.constants.levelCap) or 100
        if mon.level >= cap then return 1 end
        local rates = battle.data.growth_rates
        local cur = Growth.expForLevel(def.growthRate, mon.level, rates)
        local nxt = Growth.expForLevel(def.growthRate, mon.level + 1, rates)
        local span = nxt - cur
        if span <= 0 then return 0 end
        return math.max(0, math.min(1, ((mon.exp or cur) - cur) / span))
      end

      local function drawBattleExp(battle)
        if not mod.options:get("battle_exp_bar") then return end
        if not battle or battle.safari or battle.demo or battle.showPlayerBack then return end
        if (battle.introSlide or 0) ~= 0 then return end
        -- Only draw on the uncovered base battle HUD. The current Recomp
        -- keeps the battle rendering beneath pushed screens, and its move
        -- selector is owned by the battle itself (phase="move"). Without
        -- both guards the EXP strip bleeds into move/type/info pages.
        local stack = battle.game and battle.game.stack
        if stack and stack.top and stack:top() ~= battle then return end
        -- Recomp's battle state can keep drawing beneath move/type overlays
        -- without changing phase. bottomUIVisible() is the semantic guard
        -- used by the engine for whether the base battle command HUD owns
        -- this region; if another battle UI owns it, suppress the EXP strip.
        -- 0.2.56 names these phases moveSelect/mimicSelect. Suppress our
        -- custom strip whenever the move/type chooser owns the lower battle UI.
        if battle.phase == "moveSelect" or battle.phase == "mimicSelect" then return end
        local ratio = expRatio(battle)
        if ratio == nil then return end
        local g = love.graphics
        g.push("all")
        g.setShader()
        -- Native 160px battle HUD: thin progress track directly beneath the
        -- player's status box. Wide battles get a longer equivalent track.
        if battle.wideLayout and battle:wideLayout() then
          local x, y, w = 208, 91, 80
          -- White track on the white battle field, with BLACK earned
          -- progress growing left-to-right.  DIAG37 had these colors
          -- reversed, so gaining EXP visually erased the black bar.
          g.setColor(1, 1, 1, 1)
          g.rectangle("fill", x, y, w, 2)
          if ratio > 0 then
            g.setColor(0, 0, 0, 1)
            g.rectangle("fill", x, y, math.floor(w * ratio + 0.5), 2)
          end
        else
          local x, y, w = 80, 89, 67
          -- White track on the white battle field, with BLACK earned
          -- progress growing left-to-right.  DIAG37 had these colors
          -- reversed, so gaining EXP visually erased the black bar.
          g.setColor(1, 1, 1, 1)
          g.rectangle("fill", x, y, w, 2)
          if ratio > 0 then
            g.setColor(0, 0, 0, 1)
            g.rectangle("fill", x, y, math.floor(w * ratio + 0.5), 2)
          end
        end
        g.pop()
      end

      mod.events:on("battle.started", function(event)
        local battle = event and event.battle
        if not battle or wrappedBattles[battle] or type(battle.draw) ~= "function" then return end
        wrappedBattles[battle] = true
        local originalDraw = battle.draw
        battle.draw = function(self, ...)
          originalDraw(self, ...)
          local ok, err = pcall(drawBattleExp, self)
          if not ok then
            mod.log:error("Battle EXP bar draw failed: %s", tostring(err))
          end
        end
      end)
    end
  end

  -- Battle caught marker -------------------------------------------------
  -- Recomp exposes the caught-ball marker as its own semantic hook, so use
  -- that instead of the old custom battle draw overlay. This restores the
  -- indicator without injecting extra dialogue/render passes.
  if mod.hooks then
    mod.hooks:wrap("battle.caught_marker_visible", function(next, battle)
      if not mod.options:get("caught_indicator") then return false end
      return true
    end)
  end

  -- Repel renewal QoL ----------------------------------------------------
  -- Ask a real question, then let the player choose among every Repel type
  -- they currently carry instead of silently consuming MAX REPEL.
  do
    local RepelOW = require("src.world.OverworldController")
    local RepelTextBox = require("src.render.TextBox")
    local RepelActionChoice = ActionChoice
    if not RepelOW._vanillaPlusRepelRenewWrapped then
      RepelOW._vanillaPlusRepelRenewWrapped = true
      local nativeOnStepComplete = RepelOW.onStepComplete
      function RepelOW:onStepComplete(...)
        local before = gameRef and gameRef.save and gameRef.save.repelSteps or 0
        local result = nativeOnStepComplete(self, ...)
        local after = gameRef and gameRef.save and gameRef.save.repelSteps or 0
        if mod.options:get("repel_reuse_prompt") and before == 1 and after == 0 then
          local inv = gameRef.save.inventory or {}
          local available = {}
          for _, id in ipairs({ "REPEL", "SUPER_REPEL", "MAX_REPEL" }) do
            if (inv[id] or 0) > 0 then available[#available + 1] = id end
          end
          if #available > 0 then
            local top = gameRef.stack and gameRef.stack:top()
            if top and top ~= self then gameRef.stack:pop() end
            local function useRepel(id)
              inv[id] = (inv[id] or 0) - 1
              if inv[id] <= 0 then inv[id] = nil end
              gameRef.save.repelSteps = id == "MAX_REPEL" and 250
                or id == "SUPER_REPEL" and 200 or 100
              local label = id == "MAX_REPEL" and "MAX REPEL"
                or id == "SUPER_REPEL" and "SUPER REPEL" or "REPEL"
              gameRef.stack:push(RepelTextBox.new(gameRef,
                ((gameRef.save.player and gameRef.save.player.name) or "RED") .. " used\n" .. label .. "!"))
            end
            local function chooseType()
              if #available == 1 then return useRepel(available[1]) end
              local rows = {}
              for _, id in ipairs(available) do
                local rid = id
                local label = rid == "MAX_REPEL" and "MAX REPEL"
                  or rid == "SUPER_REPEL" and "SUPER REPEL" or "REPEL"
                rows[#rows + 1] = { label = label, action = function() useRepel(rid) end }
              end
              rows[#rows + 1] = { label = "CANCEL", action = function() end }
              gameRef.stack:push(RepelActionChoice.new(gameRef, rows))
            end
            gameRef.stack:push(RepelTextBox.new(gameRef,
              vpFormatDialogue("REPEL's effect wore off.\fWould you like to use another?"), function()
                gameRef.stack:push(RepelActionChoice.new(gameRef, {
                  { label = "YES", action = chooseType },
                  { label = "NO", action = function() end },
                }))
              end))
          end
        end
        return result
      end
    end
  end

  local BaseSummary = require("src.ui.SummaryMenu")
  local Font = require("src.render.Font")
  local HudTiles = require("src.render.HudTiles")

  local VanillaPlusSummary = {}
  VanillaPlusSummary.__index = VanillaPlusSummary
  setmetatable(VanillaPlusSummary, { __index = BaseSummary })

  local function drawLineBox(tx, ty, b, c)
    for i = 0, b - 1 do
      HudTiles.statusTile(0x78, tx * 8, (ty + i) * 8)
    end
    HudTiles.statusTile(0x77, tx * 8, (ty + b) * 8)
    for i = 1, c do
      HudTiles.statusTile(0x76, (tx - i) * 8, (ty + b) * 8)
    end
    HudTiles.statusTile(0x6F, (tx - c - 1) * 8, (ty + b) * 8)
  end

  local function clampInteger(value, minimum, maximum)
    value = math.floor(tonumber(value) or 0)
    return math.max(minimum, math.min(maximum, value))
  end

  local function normalizedDVs(mon)
    local source = (mon and type(mon.dvs) == "table") and mon.dvs or {}
    local attack = clampInteger(source.attack, 0, 15)
    local defense = clampInteger(source.defense, 0, 15)
    local speed = clampInteger(source.speed, 0, 15)
    local special = clampInteger(source.special, 0, 15)
    local hp = (attack % 2) * 8 + (defense % 2) * 4
      + (speed % 2) * 2 + (special % 2)
    return {
      hp = hp,
      attack = attack,
      defense = defense,
      speed = speed,
      special = special,
    }
  end

  local function normalizedStatExp(mon)
    local source = (mon and type(mon.statExp) == "table") and mon.statExp or {}
    return {
      hp = clampInteger(source.hp, 0, 65535),
      attack = clampInteger(source.attack, 0, 65535),
      defense = clampInteger(source.defense, 0, 65535),
      speed = clampInteger(source.speed, 0, 65535),
      special = clampInteger(source.special, 0, 65535),
    }
  end

  function VanillaPlusSummary:update(dt)
    -- Mirror Recomp 0.2.56's Summary lifecycle before adding our third page.
    -- In particular, whiteHold MUST tick down or the native Stats/Moves pages
    -- remain permanently covered by the transition-white overlay.
    if self.closing then return end
    if self.whiteHold and self.whiteHold > 0 then
      self.whiteHold = self.whiteHold - 1
      if self.whiteHold == 0 then
        require("src.core.Sound").playCry(self.game.data, self.mon.species)
      end
      return
    end

    local input = self.game.input
    if self.page == 2 and mod.options:get("dv_summary")
      and input:wasPressed("select") then
      self.vpHiddenMode = (self.vpHiddenMode == "statExp") and "dvs" or "statExp"
      return
    end

    if input:wasPressed("a") or input:wasPressed("b") then
      if self.page < 3 then
        self.page = self.page + 1
      else
        local Transition = require("src.render.Transition")
        self.closing = true
        self.game.stack:push(Transition.whiteFlash(self.game, nil, function()
          self.game.stack:pop()
        end))
      end
    end
  end

  local function drawRows(values, valueFormat)
    local rows = {
      { "HP", values.hp },
      { "ATTACK", values.attack },
      { "DEFENSE", values.defense },
      { "SPEED", values.speed },
      { "SPECIAL", values.special },
    }

    -- Four pixels lower than the first alpha. This now shares the native
    -- moves page's first baseline and gives the top border proper breathing room.
    for i, row in ipairs(rows) do
      local y = 72 + (i - 1) * 10
      Font.draw(row[1], 16, y)
      Font.draw(valueFormat:format(row[2]), 112, y)
    end
  end

  function VanillaPlusSummary:drawHiddenStatsPage()
    -- Reuse the engine's native page-two header, portrait and palette handling,
    -- then clear only the page-specific regions we replace.
    local requestedPage = self.page
    self.page = 2
    BaseSummary.draw(self)
    self.page = requestedPage

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 64, 16, 96, 40)
    love.graphics.rectangle("fill", 0, 64, 160, 80)

    love.graphics.setColor(0, 0, 0, 1)
    drawLineBox(19, 1, 6, 10)
    Font.drawBox(0, 8, 20, 10)

    local showStatExp = mod.options:get("dv_summary")
      and self.vpHiddenMode == "statExp"

    if showStatExp then
      Font.draw("STAT EXP", 72, 24)
      Font.draw("0-65535", 88, 40)
      drawRows(normalizedStatExp(self.mon), "%5d")
      Font.draw("SELECT:DVS", 72, 128)
    else
      Font.draw("DVS", 72, 24)
      Font.draw("VALUES /15", 72, 40)
      local dvs = normalizedDVs(self.mon)
      drawRows(dvs, "%2d")
      local total = dvs.hp + dvs.attack + dvs.defense + dvs.speed + dvs.special
      Font.draw("TOTAL", 16, 128)
      Font.draw(("%2d/75"):format(total), 112, 128)
      if mod.options:get("dv_summary") then
        Font.draw("SELECT:EXP", 72, 120)
      end
    end

    love.graphics.setColor(1, 1, 1, 1)
  end

  function VanillaPlusSummary:draw()
    if self.page == 2 then
      return self:drawHiddenStatsPage()
    end

    -- Native page 1 is Stats. Vanilla+ page 3 maps to native page 2 (Moves).
    local requestedPage = self.page
    self.page = (requestedPage == 3) and 2 or 1
    BaseSummary.draw(self)
    self.page = requestedPage
  end

  mod.content.screens:register("SummaryMenu", {
    new = function(game, mon)
      local screen = BaseSummary.new(game, mon)
      if not mod.options:get("dv_summary") then
        return screen
      end
      screen.vpHiddenMode = "dvs"
      return setmetatable(screen, VanillaPlusSummary)
    end,
  })

  ---------------------------------------------------------------------------
  -- Beta 1 Hotfix 3 QA repair pass (Recomp 2 baseline)
  -- Fixes confirmed test failures without touching Grove/DIAG rendering code.
  ---------------------------------------------------------------------------
  do
    local function copySlots(slots)
      local out = {}
      for i, slot in ipairs(slots or {}) do
        local n = {}
        for k, v in pairs(slot) do n[k] = v end
        out[i] = n
      end
      return out
    end

    local function runtimeEncounter(mapId)
      local g = gameRef
      return g and g.data and g.data.encounters and g.data.encounters[mapId]
    end

    local function setEncounterSpecies(mapId, groupName, replacements)
      local enc = runtimeEncounter(mapId)
      local group = enc and enc[groupName]
      if not (group and type(group.slots) == "table" and #group.slots > 0) then
        mod.log:warn("Vanilla+ QA: no %s encounter table for %s", tostring(groupName), tostring(mapId))
        return false
      end
      local slots = copySlots(group.slots)
      local changed = false
      for _, r in ipairs(replacements or {}) do
        local i = r.slot
        if i and slots[i] then
          if r.species then slots[i].species = r.species end
          if r.level then slots[i].level = r.level end
          changed = true
        end
      end
      if changed then
        group.slots = slots
        mod.log:info("Vanilla+ QA: runtime %s encounters repaired for %s", tostring(groupName), tostring(mapId))
      end
      return changed
    end

    local function setGrassSpecies(mapId, replacements)
      return setEncounterSpecies(mapId, "grass", replacements)
    end

    local function setWaterSpecies(mapId, replacements)
      -- Recomp/data packs have used more than one label for Surf encounters.
      -- Patch every known water-group spelling and succeed if any one exists.
      local changed = false
      for _, groupName in ipairs({ "water", "surf", "surfing" }) do
        if setEncounterSpecies(mapId, groupName, replacements) then changed = true end
      end
      return changed
    end

    -- Fossil habitats intentionally cover both walkable cave floor and water.
    -- Seafoam B4F carries the basic fossil lines; Cerulean B1F carries their
    -- evolved forms. QA slots 1-7 total exactly 90% encounter weight.
    local function repairWildFossils()
      if not mod.options:get("wild_fossils") then return end
      local seafoam = {
        { slot = 7, species = "OMANYTE" },
        { slot = 8, species = "KABUTO" },
      }
      setGrassSpecies("SEAFOAM_ISLANDS_B4F", seafoam)
      setWaterSpecies("SEAFOAM_ISLANDS_B4F", seafoam)

      local cerulean = {
        { slot = 7, species = "OMASTAR" },
        { slot = 8, species = "KABUTOPS" },
        { slot = 10, species = "AERODACTYL" }, -- native 1% encounter slot
      }
      setGrassSpecies("CERULEAN_CAVE_B1F", cerulean)
      setWaterSpecies("CERULEAN_CAVE_B1F", cerulean)
    end

    -- Yellow Route 17 actually carries Ponyta; the earlier Yellow patch only
    -- covered Route 22 Mankey and Viridian Forest Pidgeotto.
    local function repairYellowRoute17()
      if not mod.options:get("yellow_route_encounters") then return end
      setGrassSpecies("ROUTE_17", {
        { slot = 4, species = "PONYTA", level = 28 },
        { slot = 7, species = "PONYTA", level = 30 },
        { slot = 8, species = "PONYTA", level = 30 },
        { slot = 9, species = "PONYTA", level = 32 },
      })
    end

    -- Machine labels -------------------------------------------------------
    -- Recomp stores machine items by move-name ids (for example TM_METRONOME)
    -- rather than guaranteed TM01..TM50 ids. Map each taught move back to its
    -- canonical Gen I machine number so the Bag reads "TM35 METRONOME" rather
    -- than concatenating the internal id into nonsense like TMMETRONOME.
    local originalMachineNames = {}
    local tmByMove = {}
    local machineTmMoves = {
      "MEGA PUNCH","RAZOR WIND","SWORDS DANCE","WHIRLWIND","MEGA KICK",
      "TOXIC","HORN DRILL","BODY SLAM","TAKE DOWN","DOUBLE-EDGE",
      "BUBBLEBEAM","WATER GUN","ICE BEAM","BLIZZARD","HYPER BEAM",
      "PAY DAY","SUBMISSION","COUNTER","SEISMIC TOSS","RAGE",
      "MEGA DRAIN","SOLARBEAM","DRAGON RAGE","THUNDERBOLT","THUNDER",
      "EARTHQUAKE","FISSURE","DIG","PSYCHIC","TELEPORT",
      "MIMIC","DOUBLE TEAM","REFLECT","BIDE","METRONOME",
      "SELFDESTRUCT","EGG BOMB","FIRE BLAST","SWIFT","SKULL BASH",
      "SOFTBOILED","DREAM EATER","SKY ATTACK","REST","THUNDER WAVE",
      "PSYWAVE","EXPLOSION","ROCK SLIDE","TRI ATTACK","SUBSTITUTE",
    }
    local function machineKey(v)
      return tostring(v or ""):upper():gsub("[^A-Z0-9]", "")
    end
    for n, moveName in ipairs(machineTmMoves) do
      tmByMove[machineKey(moveName)] = n
    end
    local hmByMove = { CUT = 1, FLY = 2, SURF = 3, STRENGTH = 4, FLASH = 5 }
    local compactMachineMove = {
      ["MEGA PUNCH"] = "MEGA PCH", ["RAZOR WIND"] = "RAZR WIND",
      ["SWORDS DANCE"] = "SWORDS DN", ["MEGA KICK"] = "MEGA KCK",
      ["HORN DRILL"] = "HORNDRIL", ["BODY SLAM"] = "BODYSLAM",
      ["DOUBLE-EDGE"] = "DBL-EDGE", ["BUBBLEBEAM"] = "BUBBLEBM",
      ["WATER GUN"] = "WATERGUN", ["HYPER BEAM"] = "HYPER BM",
      ["SEISMIC TOSS"] = "SEIS TOSS", ["MEGA DRAIN"] = "MEGA DRN",
      ["SOLARBEAM"] = "SOLAR BM", ["DRAGON RAGE"] = "DRGN RAGE",
      ["THUNDERBOLT"] = "T-BOLT", ["EARTHQUAKE"] = "EARTHQKE",
      ["DOUBLE TEAM"] = "DBL TEAM", ["SELFDESTRUCT"] = "SELFDEST",
      ["SKULL BASH"] = "SKULLBASH", ["DREAM EATER"] = "DRM EATR",
      ["THUNDER WAVE"] = "T-WAVE", ["ROCK SLIDE"] = "ROCKSLIDE",
      ["TRI ATTACK"] = "TRI ATK", ["SUBMISSION"] = "SUBMISS",
    }

    local function repairMachineNames()
      local g = gameRef
      if not (g and g.data and g.data.items and g.data.moves) then return end
      for id, def in pairs(g.data.items) do
        if type(def) == "table" and def.machine and def.machine.move then
          if originalMachineNames[id] == nil then originalMachineNames[id] = def.name end
          if mod.options:get("tm_move_names") then
            local moveId = def.machine.move
            local move = g.data.moves[moveId]
            local moveName = (move and move.name) or tostring(moveId):gsub("_", " ")
            local key = machineKey(moveName)
            local tmNum = tmByMove[key]
            local hmNum = hmByMove[key]
            local displayMove = compactMachineMove[moveName] or moveName
            if tmNum then
              def.name = string.format("TM%02d %s", tmNum, displayMove)
            elseif hmNum then
              def.name = string.format("HM%02d %s", hmNum, displayMove)
            else
              -- Unknown/custom machine: retain its original item label instead
              -- of exposing an internal resource id to the player.
              def.name = originalMachineNames[id] or def.name
            end
          else
            def.name = originalMachineNames[id] or def.name
          end
        end
      end
    end

    mod.events:on("game.ready", function()
      repairWildFossils()
      repairYellowRoute17()
      repairMachineNames()
    end)
    mod.events:on("mod.options_changed", function(ev)
      if not ev then return end
      if ev.key == "tm_move_names" then repairMachineNames() end
    end)

    -- Recomp 0.2.56 may rebuild item definitions after game.ready. Reapply
    -- machine display names at the point of use so the option cannot appear to
    -- "forget" TM names until the player toggles it off and back on.
    do
      local okBagNames, BagMenuNames = pcall(require, "src.ui.BagMenu")
      if okBagNames and BagMenuNames and not BagMenuNames._vanillaPlusTMNameRefreshWrapped then
        BagMenuNames._vanillaPlusTMNameRefreshWrapped = true
        local previousBagNewForNames = BagMenuNames.new
        function BagMenuNames.new(g, opts)
          repairMachineNames()
          local list = previousBagNewForNames(g, opts)
          if list and type(list.update) == "function" and not list._vanillaPlusTMNameRefreshUpdate then
            list._vanillaPlusTMNameRefreshUpdate = true
            local previousUpdateForNames = list.update
            function list:update(dt, ...)
              -- 0.2.56 can refresh item definitions/menu rows during UI state
              -- changes. Repair names immediately before the native update so
              -- any rebuilt rows inherit the option-selected TM labels.
              repairMachineNames()
              return previousUpdateForNames(self, dt, ...)
            end
          end
          return list
        end
      end
    end
    mod.events:on("map.entered", function() repairMachineNames() end)

    -- AREA integration ----------------------------------------------------
    -- QA1 tried to normalize encounter ids with a loose prefix match. That
    -- made ROUTE_17 match ROUTE_1 (and similar pairs), spraying nest icons
    -- across Kanto. Recomp 2 already indexes runtime encounter tables by the
    -- canonical map ids we patch, so leave TownMap's native exact lookup alone.

    -- Vanilla+ expanded Fly destinations ----------------------------------
    -- Post-Champion Toolkit/Balloon travel keeps the normal Town Map but adds
    -- useful landmark landings that vanilla's city-only Fly filter cannot
    -- represent. Synthetic ids let multiple destinations share one outdoor map
    -- (for example ROUTE_10 Center + Power Plant) without overwriting each
    -- other's landing coordinates.
    local VP_FLY_TARGETS = {
      VP_MT_MOON_CENTER = {
        label = "MT MOON CENTER", map = "ROUTE_4", x = 11, y = 6,
      },
      VP_ROCK_TUNNEL_CENTER = {
        label = "ROCK TUNNEL CENTER", map = "ROUTE_10", x = 11, y = 20,
      },
      VP_SEAFOAM_WEST = {
        label = "SEAFOAM WEST", map = "ROUTE_20", x = 48, y = 6,
      },
      VP_SEAFOAM_EAST = {
        label = "SEAFOAM EAST", map = "ROUTE_20", x = 58, y = 10,
      },
      VP_VICTORY_ROAD = {
        label = "VICTORY ROAD", map = "ROUTE_23", x = 4, y = 32,
      },
      VP_CERULEAN_CAVE = {
        label = "CERULEAN CAVE", map = "CERULEAN_CITY", x = 4, y = 12,
      },
      VP_POWER_PLANT = {
        label = "POWER PLANT", map = "ROUTE_10", x = 6, y = 40,
      },
    }
    local VP_FLY_ORDER = {
      "VP_MT_MOON_CENTER",
      "VP_ROCK_TUNNEL_CENTER",
      "VP_SEAFOAM_WEST",
      "VP_SEAFOAM_EAST",
      "VP_VICTORY_ROAD",
      "VP_CERULEAN_CAVE",
      "VP_POWER_PLANT",
    }

    -- Teach the real overworld Fly routine about our synthetic destination
    -- ids while retaining Recomp's proven Fly animation and arrival pipeline.
    local okFlyOW, FlyOW = pcall(require, "src.world.OverworldController")
    if okFlyOW and FlyOW and not FlyOW._vanillaPlusExpandedFly then
      FlyOW._vanillaPlusExpandedFly = true
      local nativeFlyTo = FlyOW.flyTo
      function FlyOW:flyTo(mapId)
        local target = VP_FLY_TARGETS[mapId]
        if not target then return nativeFlyTo(self, mapId) end
        local Game = require("src.core.Game")
        Game.save.onBike = false
        Game.save.forcedBike = nil
        self.player.surfing = false
        self:syncSurfingPikachu()
        self.flyAnim = { phase = "flap", t = 0 }
        self.player.inputLocked = true
        self.flyDest = { map = target.map, x = target.x, y = target.y }
      end
    end

    local okTownFly, TownMapFly = pcall(require, "src.ui.TownMap")
    if okTownFly and TownMapFly and not TownMapFly._vanillaPlusExpandedFly then
      TownMapFly._vanillaPlusExpandedFly = true
      local nativeTownMapNew = TownMapFly.new
      TownMapFly.new = function(game, opts)
        local self = nativeTownMapNew(game, opts)
        if not (opts and opts.fly and mod.options:get("fly_to_centers") and self) then
          return self
        end

        -- The Toolkit is post-Champion, so these landmarks are safe to expose
        -- there without creating an early-game sequence break. For ordinary HM
        -- Fly, keep them gated behind Champion as well.
        local flags = game.save.flags or {}
        if not flags.EVENT_BEAT_CHAMPION_RIVAL then return self end

        local flyLocs, flyMapIds = {}, {}
        local seen = {}

        -- Preserve every normal destination Recomp already considers legal.
        for i, loc in ipairs(self.locs or {}) do
          local id = self.flyMapIds and self.flyMapIds[i]
          if id and not VP_FLY_TARGETS[id] and not seen[id] then
            seen[id] = true
            flyLocs[#flyLocs + 1] = loc
            flyMapIds[#flyLocs] = id
          end
        end

        -- Append Vanilla+ landmarks. Reuse the outdoor map's Town Map square
        -- so the cursor still renders on the canonical Kanto map.
        for _, id in ipairs(VP_FLY_ORDER) do
          local target = VP_FLY_TARGETS[id]
          local baseLoc = self.byMap and self.byMap[target.map]
          local loc
          if baseLoc then
            loc = { name = target.label, x = baseLoc.x, y = baseLoc.y }
          else
            loc = { name = target.label }
          end
          flyLocs[#flyLocs + 1] = loc
          flyMapIds[#flyLocs] = id
        end

        if #flyLocs > 0 then
          self.fly = true
          self.onFly = opts.onFly
          self.locs = flyLocs
          self.flyMapIds = flyMapIds
          self.sel = 1
          if self.mode == "grid" then
            for _, loc in ipairs(flyLocs) do
              if not (loc.x and loc.y) then self.mode = "list" break end
            end
          end
        end
        return self
      end
    end


  -- Professor Oak: completed-Pokedex life ---------------------------------
  -- Once Red has caught the 150 standard Kanto species, Oak acknowledges
  -- completion once and Vanilla+ permanently retires his repetitive vanilla
  -- Dex-evaluation interaction.  Later story/event hooks should be checked
  -- before this idle chatter so important Oak scenes always win priority.
  do
    local okOak, OakOverworld = pcall(require, "src.world.OverworldController")
    local okOakText, OakTextBox = pcall(require, "src.render.TextBox")

    local function oakOwnedCount(game)
      local dex = game and game.save and game.save.pokedex
      local owned = dex and dex.owned
      if type(owned) ~= "table" then return 0 end

      local count = 0
      for species, value in pairs(owned) do
        if value then
          local id = tostring(species or ""):upper()
          -- Gen I's official completion requirement is the 150 standard
          -- species. Mew is intentionally bonus content and MissingNo-style
          -- debug/glitch entries must never satisfy the completion gate.
          if id ~= "MEW" and not id:find("MISSING", 1, true)
            and id ~= "NONE" and id ~= "NO_POKEMON" then
            count = count + 1
          end
        end
      end
      return count
    end

    local function oakDexComplete(game)
      return oakOwnedCount(game) >= 150
    end

    local function isProfessorOak(ow, npc)
      if not (ow and ow.map and ow.map.id == "OAKS_LAB" and npc) then
        return false
      end
      local def = npc.def or {}
      local name = tostring(def.name or npc.name or ""):upper()
      local sprite = tostring(def.sprite or npc.sprite or ""):upper()
      return name:find("OAK", 1, true) ~= nil
        or sprite == "SPRITE_OAK"
        or sprite:find("OAK", 1, true) ~= nil
    end

    local oakLines = {
      "OAK: RED! Good timing!\fI was just thinking\nabout lunch.\fA sandwich sounds\nquite good, actually.",
      "OAK: TEAM ROCKET...\fI wonder what became\nof those fellows.\fPerhaps I'm better\noff not knowing.",
      "OAK: That POKeDEX is\nremarkable!\fTo think we once knew\nso little about POKeMON.\f...Well, I knew quite\na lot.",
      "OAK: My grandson stopped\nby earlier.\fWhat was his name\nagain?\f...Never mind.",
      "OAK: The weather has\nbeen strange lately.\fPerhaps I should\nstudy that next.\fNo. One lifetime\nis enough.",
      "OAK: RED...\fHave you ever noticed\nI'm always standing\nhere?\f...Hm.",
      "OAK: Technology is\nincredible!\fThey say someday people\nmay carry computers\nin their pockets!\fImagine that!",
      "OAK: 150 POKeMON...\fA nice, sensible\nnumber.\fSurely there can't be\nmany more.",
      "OAK: I received a letter\nfrom a young researcher\nin JOHTO.\fVery enthusiastic\nfellow.\fHe asks a lot of\nquestions.",
      "OAK: You've become quite\nthe POKeMON TRAINER,\nRED!\f...\fYou were always a\ngood listener.",
      "OAK: BILL is an\nextraordinary young man.\fA little eccentric,\nperhaps.\fMost brilliant people\nare.",
      "OAK: You caught every\nkind of POKeMON...\fWhen I asked you to\ncomplete the POKeDEX,\nI hadn't expected such\nenthusiasm.\fRemarkable!",
      "OAK: Some TRAINERS tell\nstories of strange\nPOKeMON near CINNABAR.\fNonsense, surely.\f...Surely.",
      "OAK: People seem to be\nin such a hurry these\ndays.\fPerhaps everyone should\nspend more time fishing.\fThat's what I'd do.",
      "OAK: RED.\fThere will always be\nsomething new to\ndiscover.\fThat's what makes being\na POKeMON TRAINER so\nexciting!",
      "OAK: I could use a cup\nof tea.\fResearch is thirsty\nwork, RED!",
      "OAK: I've misplaced my\nnotes again.\fThey were right here...\fHm. Perhaps I should\nmake notes about them.",
      "OAK: POKEMON habitats\ncan change over time.\fA good researcher\nnever assumes the map\nis finished.",
      "OAK: Evolution still\nholds many mysteries.\fEven after all this\nresearch, we keep\nlearning more.",
      "OAK: The SAFARI ZONE is\na remarkable place.\fI'd lose an afternoon\nthere if I weren't\ncareful.",
      "OAK: BLAINE has always\nhad a sharp mind.\fAnd an even sharper\ntemper, at times!",
      "OAK: MR.FUJI is a kind\nman.\fKANTO could use more\npeople like him.",
      "OAK: The INDIGO LEAGUE\nhas changed since I\nwas young.\fSome things haven't.\fTRAINERS still hate\nlosing!",
      "OAK: Your mother must be\nvery proud, RED.\fYou should visit her\nnow and then!",
      "OAK: BLUE trains hard.\fHe always has.\fCompetition can bring\nout the best in a\nTRAINER.",
      "OAK: DAISY stopped by\nwith some tea earlier.\fMuch more reliable\nthan her brother!",
      "OAK: Sometimes the best\nresearch begins with\na very simple question.\fWhy?",
      "OAK: I wonder what POKEMON\nlive beyond KANTO.\fA researcher could\nspend a lifetime finding\nout.",
      "OAK: Don't neglect the\nPOKEMON you've already\nmet, RED.\fKnowing a species is\nmore than catching one.",
      "OAK: I used to travel\nmuch more than I do\nnow.\fThese days, the world\nseems to come to my lab!",
    }

    -- Shuffle-bag selection: every eligible Oak line is heard once before
    -- the pool reshuffles, and a cycle boundary cannot immediately repeat.
    local function pickOakLine()
      local last = tonumber(mod.save:get("oak_postdex_last_line_v2"))
      local bag = tostring(mod.save:get("oak_postdex_bag_v2") or "")
      local choices = {}
      for n in bag:gmatch("%d+") do choices[#choices + 1] = tonumber(n) end
      if #choices == 0 then
        for i = 1, #oakLines do choices[i] = i end
        for i = #choices, 2, -1 do
          local j = love.math.random(i)
          choices[i], choices[j] = choices[j], choices[i]
        end
        if last and #choices > 1 and choices[#choices] == last then
          choices[1], choices[#choices] = choices[#choices], choices[1]
        end
      end
      local index = table.remove(choices)
      mod.save:set("oak_postdex_last_line_v2", index)
      mod.save:set("oak_postdex_bag_v2", table.concat(choices, ","))
      return oakLines[index]
    end

    local function oakHasHigherPriorityEvent(ow, npc)
      -- Reserved extension point for Champion Kanto / Mew-era Oak scenes.
      -- Those event checks belong here and must return true BEFORE generic
      -- post-Dex chatter is allowed to intercept Oak's normal interaction.
      return false
    end

    if okOak and okOakText and OakOverworld and OakTextBox
      and not OakOverworld._vanillaPlusOakPostDexWrapped then
      OakOverworld._vanillaPlusOakPostDexWrapped = true
      local previousOakTalkTo = OakOverworld.talkTo

      function OakOverworld:talkTo(npc)
        local game = gameRef
        if mod.options:get("oak_postdex_life")
          and isProfessorOak(self, npc)
          and not oakHasHigherPriorityEvent(self, npc) then

          if mod.save:get("oak_dex_complete_v1") then
            npc:facePlayer(self.player)
            game.stack:push(OakTextBox.new(game, vpFormatDialogue(pickOakLine())))
            return
          end

          if oakDexComplete(game) then
            -- Set immediately so a save/reload or interrupted text sequence
            -- cannot make Oak repeatedly rediscover the completed Pokedex.
            mod.save:set("oak_dex_complete_v1", true)
            npc:facePlayer(self.player)
            game.stack:push(OakTextBox.new(game, vpFormatDialogue(
              "OAK: RED!\fThis is incredible!\fYou've completed the\nPOKeDEX!\fWhen I gave you that\ndevice, I dreamed of\nthis day.\fYou've done something\ntruly remarkable.\fI'm proud of you, RED!")))
            return
          end
        end

        return previousOakTalkTo(self, npc)
      end
    end


  -- test56: robust mart TM row renderer -----------------------------------
  -- Detect the real shop list from its row contents instead of relying on
  -- constructor option flags, which differ across BUY/SELL paths.  Any item
  -- list containing a priced TM row is treated as a TM Mart list while the
  -- TM MARTS option is enabled.  Full TM labels stay in the stock list and
  -- the selected TM price moves to the footer so label and price can never
  -- occupy the same horizontal pixels.
  do
    local okList56, ListMenu56 = pcall(require, "src.ui.ListMenu")
    local okFont56, Font56 = pcall(require, "src.render.Font")
    local okTheme56, Theme56 = pcall(require, "src.ui.Theme")
    local okStrings56, Strings56 = pcall(require, "src.core.Strings")
    local okTB56, TextBox56 = pcall(require, "src.render.TextBox")
    if okList56 and okFont56 and okTheme56 and okStrings56 and okTB56
      and ListMenu56 and not ListMenu56._vanillaPlusMartRowsTest56 then
      ListMenu56._vanillaPlusMartRowsTest56 = true
      local nativeDraw56 = ListMenu56.drawItemBox

      local function isTMRow56(list, item)
        if not item then return false end
        local label = tostring(item.label or "")
        if label:match("^TM%d%d%s") then return true end
        if item.value and list and list.game and list.game.data and list.game.data.items then
          local def = list.game.data.items[item.value]
          return def and def.machine and tostring(item.value):sub(1,2) ~= "HM"
        end
        return false
      end

      local function isMartTMList56(list)
        if not mod.options:get("tm_marts") or not list or type(list.items) ~= "table" then return false end
        local hasTM, hasShopRHS = false, false
        for _,item in ipairs(list.items) do
          if isTMRow56(list,item) then hasTM = true end
          if item and (item.price ~= nil or item.sub ~= nil) then hasShopRHS = true end
        end
        -- BUY lists expose price/sub fields.  This excludes the TM/HM Bag,
        -- whose rows contain machines but no shop price column.
        return hasTM and hasShopRHS
      end

      function ListMenu56:drawItemBox()
        -- test60: retire the class-wide test58 renderer. Live ShopMenu BUY/SELL
        -- lists are handled per-instance below, after construction.
        return nativeDraw56(self)
        --[[ test58: clean item-aware TM shop hook.
        -- Preserve the engine's native ListMenu renderer for EVERYTHING.
        -- For actual TM rows only, temporarily hide the right-side shop field
        -- so the full TM## MOVE NAME gets the entire native row. Then restore
        -- the data and draw that field underneath at half scale, right-aligned.
        if not (mod.options:get("tm_marts") and self and type(self.items)=="table") then
          return nativeDraw56(self)
        end

        local tmVisible={}
        for row=1,(self.rows or 0) do
          local i=(self.scroll or 0)+row
          local item=self.items[i]
          if item and isTMRow56(self,item) then
            local rhs=item.price or item.sub or item.right
            if rhs~=nil then
              tmVisible[#tmVisible+1]={item=item,row=row,rhs=tostring(rhs),price=item.price,sub=item.sub,right=item.right}
              item.price=nil; item.sub=nil; item.right=nil
            end
          end
        end

        -- Native renderer handles box geometry, normal items, cursor, scrolling,
        -- SELL quantities, more-arrow, footer/message box, and all future UI changes.
        local ok,err=pcall(nativeDraw56,self)

        -- Always restore row data, even if the renderer faults.
        for _,r in ipairs(tmVisible) do
          r.item.price=r.price; r.item.sub=r.sub; r.item.right=r.right
        end
        if not ok then error(err) end

        -- Draw only the TM secondary value. Physical position is the lower half
        -- of the 16px row. At 0.5 scale the text keeps natural proportions and
        -- gives the full-size TM name the whole horizontal lane above it.
        if #tmVisible>0 then
          love.graphics.push()
          love.graphics.scale(0.5,0.5)
          love.graphics.setColor(0,0,0,1)
          for _,r in ipairs(tmVisible) do
            local y=32+(r.row-1)*16+8
            local w=Font56.width(r.rhs)
            local x=152-(w*0.5)
            Font56.draw(r.rhs,x*2,y*2)
          end
          love.graphics.pop()
          love.graphics.setColor(1,1,1,1)
        end
        ]]
      end
    end


  -- test60: per-instance BUY/SELL TM row renderer -------------------------
  -- ShopMenu's live BUY and SELL lists do not reliably share the same class
  -- draw path. Tag and wrap the actual ListMenu instance when its semantic
  -- title is BUY or SELL. Native rendering remains authoritative for every
  -- normal item. Only true TM rows temporarily suppress their RHS value, then
  -- redraw it underneath at half scale, right-aligned.
  do
    local okList59,ListMenu59=pcall(require,"src.ui.ListMenu")
    local okFont59,Font59=pcall(require,"src.render.Font")
    if false and okList59 and okFont59 and ListMenu59 and Font59 and type(ListMenu59.new)=="function"
      and not ListMenu59._vanillaPlusShopInstanceTMTest60 then
      ListMenu59._vanillaPlusShopInstanceTMTest60=true
      local previousNew59=ListMenu59.new

      local function isTMItem59(list,item)
        if not item then return false end
        local label=tostring(item.label or "")
        if label:match("^TM%d%d%s") then return true end
        local id=item.value
        local data=list and list.game and list.game.data and list.game.data.items
        local def=id and data and data[id]
        return def and def.machine and tostring(id):sub(1,2)~="HM" or false
      end

      function ListMenu59.new(g,title,items,opts)
        local list=previousNew59(g,title,items,opts)
        local shopTitle=tostring(title or ""):upper()
        if list and (shopTitle=="BUY" or shopTitle=="SELL") and not list._vpTMShopRows59 then
          list._vpTMShopRows59=true
          local nativeInstanceDraw=list.drawItemBox
          if type(nativeInstanceDraw)=="function" then
            function list:drawItemBox(...)
              if not mod.options:get("tm_marts") or type(self.items)~="table" then
                return nativeInstanceDraw(self,...)
              end

              local visible={}
              local rows=self.rows or 0
              local scroll=self.scroll or 0
              for row=1,rows do
                local i=scroll+row
                local item=self.items[i]
                if item and isTMItem59(self,item) then
                  -- Different shop paths expose the RHS as sub/price/right.
                  -- Save every candidate, suppress all of them for native draw,
                  -- and choose the first populated value for the secondary line.
                  local rhs=item.sub
                  if rhs==nil then rhs=item.price end
                  if rhs==nil then rhs=item.right end
                  if rhs~=nil then
                    visible[#visible+1]={
                      item=item,row=row,rhs=tostring(rhs),
                      sub=item.sub,price=item.price,right=item.right
                    }
                    item.sub=nil; item.price=nil; item.right=nil
                  end
                end
              end

              local ok,res=pcall(nativeInstanceDraw,self,...)
              for _,r in ipairs(visible) do
                r.item.sub=r.sub; r.item.price=r.price; r.item.right=r.right
              end
              if not ok then error(res) end

              if #visible>0 then
                love.graphics.push()
                love.graphics.scale(0.5,0.5)
                love.graphics.setColor(0,0,0,1)
                for _,r in ipairs(visible) do
                  local y=32+(r.row-1)*16+8
                  local w=Font59.width(r.rhs)
                  local x=152-(w*0.5)
                  Font59.draw(r.rhs,x*2,y*2)
                end
                love.graphics.pop()
                love.graphics.setColor(1,1,1,1)
              end
              return res
            end
          end
        end
        return list
      end
    end
  end


  -- test60: clean item-aware TM shop row renderer -------------------------
  -- Shop BUY/SELL lists are ordinary ListMenu item-box lists (title=nil,
  -- dialogue=true, itemBox=true). The native renderer ALREADY draws price /
  -- quantity on y+8, i.e. the lower half of each 16px row. Preserve that.
  -- Only real TM rows reclaim the unused left gutter for their full label and
  -- move their cursor with it. Every non-TM row is drawn at the exact native
  -- coordinates. No Font hooks and no coordinate-based guessing.
  do
    local okList60,ListMenu60=pcall(require,"src.ui.ListMenu")
    local okFont60,Font60=pcall(require,"src.render.Font")
    local okTheme60,Theme60=pcall(require,"src.ui.Theme")
    local okStrings60,Strings60=pcall(require,"src.core.Strings")
    if false and okList60 and okFont60 and okTheme60 and okStrings60 and ListMenu60 and Font60
      and type(ListMenu60.drawItemBox)=="function" and not ListMenu60._vanillaPlusTMShopRowsTest60 then
      ListMenu60._vanillaPlusTMShopRowsTest60=true
      local nativeDraw60=ListMenu60.drawItemBox

      local function isShopList60(self)
        -- test64: BUY-only. ShopMenu BUY rows carry item.price; SELL rows
        -- carry item.right. Require a priced TM row so the Toolkit giant SELL
        -- bag and every non-shop item list stay on their already-passing path.
        if not mod.options:get("tm_marts") or not self or not self.dialogue
          or not self.itemBox or type(self.items)~="table" then return false end
        for _,item in ipairs(self.items) do
          if item and item.price~=nil and tostring(item.label or ""):match("^TM%d%d%s") then
            return true
          end
        end
        return false
      end

      local function tmInfo60(self,item)
        if not item or item.cancel then return nil end
        -- Use the literal row identity the player actually sees. This is both
        -- robust and narrow: only labels beginning TM## are reformatted.
        local rawLabel=tostring(item.label or "")
        local prefix=rawLabel:match("^(TM%d%d)%s+")
        if not prefix then return nil end
        return rawLabel
      end

      function ListMenu60:drawItemBox()
        if not isShopList60(self) then return nativeDraw60(self) end

        -- Constants copied from the current native ListMenu item-box geometry.
        local ITEM_BOX={tx=4,ty=2,tw=16,th=11}
        local ITEM_ROWS=self.rows or 4
        local ITEM_NAME_X,ITEM_TOP_Y=48,32
        local ITEM_CURSOR_X=40
        local ITEM_QTY_X,ITEM_QTY_END=112,136
        local ITEM_MORE_X,ITEM_MORE_Y=144,88

        love.graphics.setColor(1,1,1,1)
        Font60.drawBox(ITEM_BOX.tx,ITEM_BOX.ty,ITEM_BOX.tw,ITEM_BOX.th)
        love.graphics.setColor(0,0,0,1)
        if #self.items==0 then Font60.draw(Strings60("Nothing here."),ITEM_NAME_X,ITEM_TOP_Y) end

        local shown,sawCancel=0,false
        for row=1,ITEM_ROWS do
          local i=(self.scroll or 0)+row
          local item=self.items[i]
          if not item then break end
          shown=shown+1
          if item.cancel then sawCancel=true end
          local y=ITEM_TOP_Y+(row-1)*16
          local tmLabel=tmInfo60(self,item)
          local nameX=tmLabel and 16 or ITEM_NAME_X
          local cursorX=tmLabel and 8 or ITEM_CURSOR_X
          Font60.draw(tmLabel or item.label,nameX,y)

          -- Ordinary rows keep native RHS geometry. TM rows use the same
          -- lower-half placement at half scale, right-aligned, so the full TM
          -- name owns the entire top line without a collision.
          local rhs=item.sub or item.price or item.right
          if tmLabel and rhs then
            local text=tostring(rhs)
            love.graphics.push()
            love.graphics.scale(0.5,0.5)
            local rightPx=152
            local drawX=rightPx*2-Font60.width(text)
            Font60.draw(text,drawX,(y+8)*2)
            love.graphics.pop()
          elseif item.sub then
            Font60.draw(item.sub,ITEM_QTY_X,y+8)
          elseif item.price then
            Font60.draw(item.price,ITEM_QTY_END-Font60.width(item.price),y+8)
          elseif item.right then
            local count=item.right:sub(2)
            Font60.draw(item.right:sub(1,1),ITEM_QTY_X,y+8)
            Font60.draw(count,ITEM_QTY_END-Font60.width(count),y+8)
          end

          if i==self.index and (self.cursorBlank or 0)==0 then
            Font60.drawCode(self.hollowIndex==i and Theme60.cursorHollow or Theme60.cursor,cursorX,y)
          end
          if self.swapIndex==i and i~=self.index then
            Font60.drawCode(Theme60.cursorHollow,cursorX,y)
          end
        end
        if shown==ITEM_ROWS and not sawCancel then Font60.drawCode(Theme60.moreArrow,ITEM_MORE_X,ITEM_MORE_Y) end

        -- BUY dialogue money box (MONEY_BOX 11,0). The class override owns
        -- the full item-box draw while active, so preserve this explicitly.
        if self.dialogue and self.money then
          Font60.drawBox(11,0,9,3)
          love.graphics.setColor(0,0,0,1)
          local money=("¥%d"):format(self.money() or 0)
          Font60.draw(money,152-Font60.width(money),8)
        end

        -- Preserve native shop footer/message box.
        if self.messageBox or self.footer then
          Font60.drawBox(0,12,20,6)
          love.graphics.setColor(0,0,0,1)
          if self.footer then
            local flat={}
            local TextBox60=require("src.render.TextBox")
            for _,page in ipairs(TextBox60.paginate(self.footer)) do
              for _,line in ipairs(page) do flat[#flat+1]=line end
            end
            local yy=112
            for j=math.max(1,#flat-1),#flat do Font60.draw(flat[j],8,yy); yy=yy+16 end
          end
        end
        love.graphics.setColor(1,1,1,1)
      end
    end
  end


  -- test57: final TM mart row composition shim ----------------------------
  -- Previous attempts patched ListMenu, but the live shop path can render
  -- through a different instance.  This hooks the shared font layer only for
  -- mart rows: TM labels reclaim the unused left margin and their prices move
  -- to the second half of the 16px row.  Ordinary item rows are untouched.
  do
    local okFont57,Font57=pcall(require,"src.render.Font")
    if okFont57 and Font57 and type(Font57.draw)=="function" and not Font57._vanillaPlusTMMartRowsTest57 then
      Font57._vanillaPlusTMMartRowsTest57=true
      local nativeDraw57=Font57.draw
      local nativeCode57=Font57.drawCode
      local tmRowY57={}
      local pendingY57=nil
      local martMaps57={
        PEWTER_MART=true,CERULEAN_MART=true,VERMILION_MART=true,LAVENDER_MART=true,
        FUCHSIA_MART=true,SAFFRON_MART=true,CINNABAR_MART=true,VIRIDIAN_MART=true,
        INDIGO_PLATEAU_LOBBY=true,CELADON_MART_2F=true,CELADON_MART_5F=true,
      }
      local function inTMMart57()
        return false -- test58: retired coordinate/glyph hook; it corrupted scrolling shop rows
        --[[ if not mod.options:get("tm_marts") then return false end
        local ow=gameRef and gameRef.overworld
        local id=ow and ow.map and ow.map.id
        return martMaps57[id] and true or false ]]
      end
      function Font57.draw(text,x,y,...)
        local t=tostring(text or "")
        if inTMMart57() and type(y)=="number" and y>=24 and y<=104 then
          if t:match("^TM%d%d%s") then
            pendingY57=y
            tmRowY57[y]=true
            -- The stock list normally wastes a large left gutter.  Reclaim it
            -- for TM move names so even EARTHQUAKE/SKY ATTACK fit naturally.
            return nativeDraw57(text,16,y,...)
          elseif pendingY57 and y==pendingY57 and type(x)=="number" and x>=96 then
            -- This is the inline price drawn immediately after the TM label.
            -- Put it on the lower half of the same 16px row instead of on top
            -- of the move name.
            pendingY57=nil
            return nativeDraw57(text,x,y+8,...)
          end
        end
        if pendingY57 and y~=pendingY57 then pendingY57=nil end
        return nativeDraw57(text,x,y,...)
      end
      if type(nativeCode57)=="function" then
        function Font57.drawCode(code,x,y,...)
          if inTMMart57() and tmRowY57[y] and type(x)=="number" and x>=32 and x<=48 then
            return nativeCode57(code,8,y,...)
          end
          return nativeCode57(code,x,y,...)
        end
      end
    end


  -- test63: live item-aware TM shop font bridge ----------------------------
  -- The engine's current Pokemart path builds a ListMenu item box, but runtime
  -- method replacement has proven unreliable across builds. Hook the final font
  -- calls instead, while deriving EVERY decision from the actual top ListMenu
  -- and the actual visible row item. Unlike test57, there are no remembered row
  -- coordinates: scrolling cannot make a normal item inherit TM formatting.
  do
    local okFont63,Font63=pcall(require,"src.render.Font")
    local okTheme63,Theme63=pcall(require,"src.ui.Theme")
    if okFont63 and okTheme63 and Font63 and Theme63 and type(Font63.draw)=="function"
      and not Font63._vanillaPlusLiveTMShopTest63 then
      Font63._vanillaPlusLiveTMShopTest63=true
      local nativeDraw63=Font63.draw
      local nativeCode63=Font63.drawCode

      local ITEM_TOP_Y63=32
      local ITEM_STEP63=16
      local ITEM_CURSOR_X63=40
      local ITEM_QTY_X63=112
      local SECONDARY_RIGHT63=152

      local function liveShop63()
        return nil -- test64: retired; BUY handled by item-aware ListMenu renderer
        --[[ if not mod.options:get("tm_marts") then return nil end
        local stack=gameRef and gameRef.stack
        local top=stack and stack.top and stack:top() or nil
        -- ShopMenu.buy/sell construct dialogue item-box ListMenus. BUY always
        -- supplies money; SELL does too in current Gen1Recomp. Requiring it keeps
        -- Bag/PC item lists completely outside this shim.
        if top and top.dialogue and top.itemBox and top.money and type(top.items)=="table" then
          return top
        end
        return nil
        ]]
      end

      local function rowItem63(list,topY)
        if not list or type(topY)~="number" then return nil end
        local rel=topY-ITEM_TOP_Y63
        if rel<0 or rel%ITEM_STEP63~=0 then return nil end
        local row=rel/ITEM_STEP63+1
        if row<1 or row>(list.rows or 4) then return nil end
        return list.items[(list.scroll or 0)+row],row
      end

      local function isTM63(item)
        if not item or item.cancel then return false end
        return tostring(item.label or ""):match("^TM%d%d%s") ~= nil
      end

      local function drawSecondary63(item,y)
        local rhs=item and (item.price or item.sub or item.right)
        if rhs==nil then return end
        rhs=tostring(rhs)
        love.graphics.push()
        love.graphics.scale(0.5,0.5)
        local xx=SECONDARY_RIGHT63*2-Font63.width(rhs)
        nativeDraw63(rhs,xx,y*2)
        love.graphics.pop()
      end

      function Font63.draw(text,x,y,...)
        local list=liveShop63()
        if list then
          local t=tostring(text or "")
          -- Top half: only the literal TM label is moved left to reclaim the
          -- unused gutter. Full move name stays normal size.
          local item=rowItem63(list,y)
          if item and isTM63(item) and t:match("^TM%d%d%s") then
            return nativeDraw63(text,16,y,...)
          end

          -- Lower half: map y-8 back to the ACTUAL visible row. This cannot leak
          -- to another item when scrolling because the item is recomputed now.
          local lowerItem=rowItem63(list,(type(y)=="number") and (y-8) or -999)
          if lowerItem and isTM63(lowerItem) then
            if lowerItem.right then
              -- Native SELL renders × and count in two calls. Suppress the first
              -- call and use the second to draw the complete quantity once.
              if x==ITEM_QTY_X63 then return end
              drawSecondary63(lowerItem,y)
              return
            elseif lowerItem.price or lowerItem.sub then
              drawSecondary63(lowerItem,y)
              return
            end
          end
        end
        return nativeDraw63(text,x,y,...)
      end

      if type(nativeCode63)=="function" then
        function Font63.drawCode(code,x,y,...)
          local list=liveShop63()
          if list and x==ITEM_CURSOR_X63 then
            local item=rowItem63(list,y)
            if item and isTM63(item) then
              return nativeCode63(code,8,y,...)
            end
          end
          return nativeCode63(code,x,y,...)
        end
      end
    end
  end
  end
  end
  end

  end


  -- test65: patch the ACTUAL live BUY ListMenu instance -------------------
  do
    local okShop65, ShopMenu65 = pcall(require, "src.ui.ShopMenu")
    local okFont65, Font65 = pcall(require, "src.render.Font")
    local okTheme65, Theme65 = pcall(require, "src.ui.Theme")
    local okStrings65, Strings65 = pcall(require, "src.core.Strings")
    if false and okShop65 and okFont65 and okTheme65 and okStrings65
      and ShopMenu65 and Font65 and Theme65 and Strings65
      and type(ShopMenu65.new) == "function"
      and not ShopMenu65._vanillaPlusLiveBuyInstanceTest65 then

      ShopMenu65._vanillaPlusLiveBuyInstanceTest65 = true
      local previousShopNew65 = ShopMenu65.new

      local function isTM65(item)
        return item and not item.cancel
          and tostring(item.label or ""):match("^TM%d%d%s") ~= nil
      end

      local function installBuyRenderer65(list)
        if not list or list._vpBuyRenderer65 or type(list.items) ~= "table" then return end
        list._vpBuyRenderer65 = true

        function list:drawItemBox()
          local ITEM_BOX={tx=4,ty=2,tw=16,th=11}
          local ITEM_NAME_X,ITEM_TOP_Y=48,32
          local ITEM_CURSOR_X=40
          local ITEM_QTY_END=136
          local ITEM_MORE_X,ITEM_MORE_Y=144,88

          love.graphics.setColor(1,1,1,1)
          Font65.drawBox(ITEM_BOX.tx,ITEM_BOX.ty,ITEM_BOX.tw,ITEM_BOX.th)
          love.graphics.setColor(0,0,0,1)
          if #self.items==0 then Font65.draw(Strings65("Nothing here."),ITEM_NAME_X,ITEM_TOP_Y) end

          local shown,sawCancel=0,false
          for row=1,(self.rows or 4) do
            local i=(self.scroll or 0)+row
            local item=self.items[i]
            if not item then break end
            shown=shown+1
            if item.cancel then sawCancel=true end
            local y=ITEM_TOP_Y+(row-1)*16
            local tm=isTM65(item)

            Font65.draw(item.label, tm and 16 or ITEM_NAME_X, y)

            if tm and item.price then
              local rhs=tostring(item.price)
              love.graphics.push()
              love.graphics.scale(0.5,0.5)
              Font65.draw(rhs, 152*2-Font65.width(rhs), (y+8)*2)
              love.graphics.pop()
            elseif item.sub then
              Font65.draw(item.sub,112,y+8)
            elseif item.price then
              Font65.draw(item.price,ITEM_QTY_END-Font65.width(item.price),y+8)
            elseif item.right then
              local count=item.right:sub(2)
              Font65.draw(item.right:sub(1,1),112,y+8)
              Font65.draw(count,ITEM_QTY_END-Font65.width(count),y+8)
            end

            if i==self.index and (self.cursorBlank or 0)==0 then
              Font65.drawCode(self.hollowIndex==i and Theme65.cursorHollow or Theme65.cursor,
                              tm and 8 or ITEM_CURSOR_X,y)
            end
            if self.swapIndex==i and i~=self.index then
              Font65.drawCode(Theme65.cursorHollow,tm and 8 or ITEM_CURSOR_X,y)
            end
          end
          if shown==(self.rows or 4) and not sawCancel then
            Font65.drawCode(Theme65.moreArrow,ITEM_MORE_X,ITEM_MORE_Y)
          end
          love.graphics.setColor(1,1,1,1)
        end
      end

      function ShopMenu65.new(game, stock, onQuit)
        local menu=previousShopNew65(game,stock,onQuit)
        if menu and type(menu.items)=="table" and menu.items[1]
          and type(menu.items[1].onSelect)=="function" then
          local nativeBuy65=menu.items[1].onSelect
          menu.items[1].onSelect=function(...)
            local result=nativeBuy65(...)
            local top=game and game.stack and game.stack.top and game.stack:top() or nil
            if top and top.itemBox and top.dialogue and type(top.items)=="table" then
              installBuyRenderer65(top)
            end
            return result
          end
        end
        return menu
      end
    end
  end


  -- test73: current-Recomp native BUY row baseline -------------------------
  -- The Recomp shop UI changed geometry. Older test60/test65 ListMenu/ShopMenu
  -- overrides were still forcing the pre-update fixed 160x144 coordinates, which
  -- caused TM labels/cursors to overlap the BUY/SELL/QUIT panel and mangled the
  -- lower price line. Those legacy BUY renderers are disabled above. Current
  -- Recomp now owns item-box geometry, cursor placement, scrolling, and price
  -- placement for every row, including TMs. Inventory data is unchanged.

  -- test74: widen the current-Recomp Pokemart item box ----------------------
  -- Current Recomp already gives mart items a clean two-line name/price row,
  -- but Gen I's native 4,2 -> 19,12 item box leaves only 13 glyph columns after
  -- the cursor indent. Full `TM## MOVE NAME` labels need 15 columns. For shop
  -- item-boxes only (BUY and SELL), widen the box two tiles to the left and move
  -- the cursor/name with it. Price/sub geometry, scrolling and the bottom clerk
  -- message remain native-sized. This gives 15 full glyph columns without
  -- shrinking or truncating TM names.
  do
    local okList74, ListMenu74 = pcall(require, "src.ui.ListMenu")
    local okFont74, Font74 = pcall(require, "src.render.Font")
    local okTheme74, Theme74 = pcall(require, "src.ui.Theme")
    local okStrings74, Strings74 = pcall(require, "src.core.Strings")
    local okText74, TextBox74 = pcall(require, "src.render.TextBox")
    if okList74 and okFont74 and okTheme74 and okStrings74 and okText74
      and ListMenu74 and Font74 and Theme74 and Strings74 and TextBox74
      and type(ListMenu74.drawItemBox) == "function"
      and not ListMenu74._vanillaPlusWideMartBoxTest74 then
      ListMenu74._vanillaPlusWideMartBoxTest74 = true
      local nativeItemBox74 = ListMenu74.drawItemBox

      local function drawShopMessage74(self)
        Font74.drawBox(0, 12, 20, 6)
        love.graphics.setColor(0, 0, 0, 1)
        if not self.footer then return end
        local flat = {}
        for _, page in ipairs(TextBox74.paginate(self.footer)) do
          for _, line in ipairs(page) do flat[#flat + 1] = line end
        end
        local y = 112
        for i = math.max(1, #flat - 1), #flat do
          Font74.draw(flat[i], 8, y)
          y = y + 16
        end
      end

      function ListMenu74:drawItemBox()
        -- Only Pokemart BUY/SELL lists have both itemBox + dialogue. Bag/PC and
        -- every other ListMenu keep the exact current-Recomp renderer.
        if not (self.itemBox and self.dialogue) then
          return nativeItemBox74(self)
        end

        local BOX_TX, BOX_TY, BOX_TW, BOX_TH = 2, 2, 18, 11
        local NAME_X, TOP_Y = 32, 32
        local CURSOR_X = 24
        local QTY_X, QTY_END = 112, 136
        local MORE_X, MORE_Y = 144, 88

        love.graphics.setColor(1, 1, 1, 1)
        Font74.drawBox(BOX_TX, BOX_TY, BOX_TW, BOX_TH)
        love.graphics.setColor(0, 0, 0, 1)
        if #self.items == 0 then
          Font74.draw(Strings74("Nothing here."), NAME_X, TOP_Y)
        end

        local shown, sawCancel = 0, false
        for row = 1, self.rows do
          local i = self.scroll + row
          local item = self.items[i]
          if not item then break end
          shown = shown + 1
          if item.cancel then sawCancel = true end
          local y = TOP_Y + (row - 1) * 16
          Font74.draw(item.label, NAME_X, y)
          if item.sub then
            Font74.draw(item.sub, QTY_X, y + 8)
          elseif item.price then
            Font74.draw(item.price, QTY_END - Font74.width(item.price), y + 8)
          elseif item.right then
            local count = item.right:sub(2)
            Font74.draw(item.right:sub(1, 1), QTY_X, y + 8)
            Font74.draw(count, QTY_END - Font74.width(count), y + 8)
          end
          if i == self.index and (self.cursorBlank or 0) == 0 then
            Font74.drawCode(self.hollowIndex == i and Theme74.cursorHollow or Theme74.cursor, CURSOR_X, y)
          end
          if self.swapIndex == i and i ~= self.index then
            Font74.drawCode(Theme74.cursorHollow, CURSOR_X, y)
          end
        end
        if shown == self.rows and not sawCancel then
          Font74.drawCode(Theme74.moreArrow, MORE_X, MORE_Y)
        end
        if self.messageBox or self.footer then drawShopMessage74(self) end
        love.graphics.setColor(1, 1, 1, 1)
      end
    end
  end

end
