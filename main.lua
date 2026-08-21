-- Vanilla+ 1.1.0-beta
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
      label = "R/B/Y EXCLUSIVES",
      type = "toggle",
      default = false,
      description = "Makes version-exclusive Pokemon available in additional fitting habitats. Restart required.",
      help = "Makes version-exclusive Pokemon available in additional fitting habitats. Restart required.",
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
      label = "YELLOW ROUTE ENCOUNTERS",
      type = "toggle",
      default = false,
      description = "Adds selected Pokemon Yellow-style encounter placements to the world. Restart required.",
      help = "Adds selected Pokemon Yellow-style encounter placements to the world. Restart required.",
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
      label = "OAK POST-DEX LIFE",
      type = "toggle",
      default = true,
      description = "Gives PROF.OAK additional dialogue after major Pokedex progress.",
      help = "Gives PROF.OAK additional dialogue after major Pokedex progress.",
    },
  })

  -- Vanilla+ original overworld sprite assets -------------------------------
  -- Registered through the documented sprites registry so our NPC art is a
  -- normal Recomp field sprite, not an ad-hoc renderer. Wilds can still
  -- reskin species entities after spawn through its own refresh API.
  -- DIAG27: species-correct custom overworld art remains deferred. The prior
  -- 16x48 test assets rendered as malformed humanoid fragments. For Beta 1,
  -- Chansey/Mr. Mime intentionally use Recomp's safe classic monster fallback;
  -- proper species sprites remain a documented Coming Soon visual upgrade.

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
    if not mod.options:get("version_exclusives") then
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
      -- Keep only explicit authored form-feed beats. Inside each beat, hand
      -- line breaks are treated as ordinary spaces and the native TextBox
      -- paginator owns glyph-width wrapping, scrolling, and the two-line
      -- viewport. This mirrors base-game flow much more closely than
      -- pre-packing custom text into 18-character Lua lines.
      page = page:gsub("[\r\n\v]+", " ")
                 :gsub("%s+", " ")
                 :gsub("^%s+", "")
                 :gsub("%s+$", "")
      if page ~= "" then pages[#pages + 1] = page end
    end
    if #pages == 0 then return "" end
    return table.concat(pages, "\f")
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
  -- Release behavior: Champion + completed Bill story.  This private QA
  -- package deliberately removes ONLY the Champion gate so the complete
  -- discovery/dialogue/evolution path can be tested during the playthrough.
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
          gameRef.stack:push(TextBox.new(gameRef, shuffleBag(npc, key, pool)))
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
      if not mapId:find("POKECENTER", 1, true) then return end
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
    if mod.options:get("adventurers_toolkit") and mod.save:get("toolkit_received_v1") then return end
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

    -- Post-Champion equipment consolidation.  The original key-item ownership
    -- remains mirrored in save.inventory so vanilla scripts (Cycling Road,
    -- Snorlax, etc.) still see the items.  Vanilla+ hides consolidated gear
    -- from Bag/PC presentation and excludes it from bag slot counts, while
    -- persistent mod flags drive the Toolkit hub.
    local CONSOLIDATABLE_KEY_ITEMS = {
      "BICYCLE", "OLD_ROD", "GOOD_ROD", "SUPER_ROD",
      "ITEMFINDER", "POKE_FLUTE",
    }
    local KEY_LABEL = {
      BICYCLE = "BICYCLE", OLD_ROD = "OLD ROD", GOOD_ROD = "GOOD ROD",
      SUPER_ROD = "SUPER ROD", ITEMFINDER = "ITEMFINDER",
      POKE_FLUTE = "POKe FLUTE",
      [LAPTOP_ID] = "LAPTOP",
    }
    local function toolkitKeyFlag(id) return "toolkit_key_" .. id .. "_v1" end
    local function toolkitOwns(id) return mod.save:get(toolkitKeyFlag(id)) == true end

    local function consolidateOwnedKeyItems(g)
      if not (g and g.save and mod.save:get("toolkit_received_v1")) then return 0 end
      g.save.inventory = g.save.inventory or {}
      g.save.pcItems = g.save.pcItems or {}
      local moved = 0
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do
        local inBag = (g.save.inventory[id] or 0) > 0
        local inPC = (g.save.pcItems[id] or 0) > 0
        if inBag or inPC then
          if not toolkitOwns(id) then moved = moved + 1 end
          mod.save:set(toolkitKeyFlag(id), true)
          -- Keep a hidden ownership mirror in inventory for vanilla event
          -- checks; move any PC copy into that mirror and free the PC slot.
          g.save.inventory[id] = math.max(1, g.save.inventory[id] or 0)
          g.save.pcItems[id] = nil
        end
      end
      return moved
    end

    local function withConsolidatedInventoryHidden(g, fn)
      if not (g and g.save and mod.save:get("toolkit_received_v1")) then
        return fn()
      end
      local inv, held = g.save.inventory or {}, {}
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do
        if toolkitOwns(id) and inv[id] then
          held[id] = inv[id]
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
        return show("There's nothing here\nto use the AXE on.")
      end
      local ts = ow.map.def.tileset
      local tile = ow.map:cellTile(fx, fy)
      local isGrass = (ts == "OVERWORLD" and tile == 0x52)
      local isTree = (ts == "OVERWORLD" and tile == 0x3d)
        or (ts == "GYM" and tile == 0x50)
      if not (isTree or isGrass) then
        return show("There's nothing here\nto use the AXE on.")
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
      local tileset = ow.map and ow.map.def and tostring(ow.map.def.tileset or ""):upper() or ""
      if tileset ~= "OVERWORLD" then
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

    local function showPayload(payload, done)
      if type(payload) == "table" then payload = table.concat(payload, "\f") end
      show(payload or "It won't have any\neffect.", done)
    end

    local function useStoredKeyItem(id)
      local ow = gameRef and gameRef.overworld
      if not ow then return end
      if id == TOOLKIT_ID then return openToolkit() end
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
    end

    local function registerKeyItem(id)
      if id ~= TOOLKIT_ID and id ~= LAPTOP_ID and not toolkitOwns(id) then
        return show("That item isn't in\nthe TOOLKIT.")
      end
      mod.save:set("registered_key_item_v1", id)
      local label = id == TOOLKIT_ID and "TOOLKIT" or (KEY_LABEL[id] or id)
      show(vpFormatDialogue(label .. " was registered!\fPress SELECT in the overworld to use it.\fHold SELECT in the overworld to reopen REGISTER."))
    end

    local function openFishingGear()
      local rows = {}
      for _, id in ipairs({ "OLD_ROD", "GOOD_ROD", "SUPER_ROD" }) do
        if toolkitOwns(id) then
          local itemId = id
          rows[#rows + 1] = { label = KEY_LABEL[itemId],
            onSelect = function() useStoredKeyItem(itemId) end }
        end
      end
      if #rows == 0 then return show("No fishing rods are\nstored in the TOOLKIT.") end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16 }))
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

    local function openEquipment()
      local rows = {}
      if toolkitOwns("BICYCLE") then
        rows[#rows + 1] = { label = "BICYCLE", onSelect = function() useStoredKeyItem("BICYCLE") end }
      end
      if toolkitOwns("ITEMFINDER") then
        rows[#rows + 1] = { label = "ITEMFINDER", onSelect = function() useStoredKeyItem("ITEMFINDER") end }
      end
      if toolkitOwns("POKE_FLUTE") then
        rows[#rows + 1] = { label = "POKe FLUTE", onSelect = function() useStoredKeyItem("POKE_FLUTE") end }
      end
      if #rows == 0 then return show("No extra equipment is\nstored in the TOOLKIT.") end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16 }))
    end

    local function openRegisterMenu()
      local rows = {
        { label = "TOOLKIT", onSelect = function() registerKeyItem(TOOLKIT_ID) end },
        { label = "LAPTOP", onSelect = function() registerKeyItem(LAPTOP_ID) end },
      }
      for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do
        if toolkitOwns(id) then
          local itemId = id
          rows[#rows + 1] = { label = KEY_LABEL[itemId] or itemId,
            onSelect = function() registerKeyItem(itemId) end }
        end
      end
      rows[#rows + 1] = { label = "CANCEL" }
      gameRef.stack:push(Menu.new(gameRef, rows, { tx = 2, ty = 1, tw = 16, maxVisible = 6 }))
    end

    openToolkit = function()
      if not gameRef then return end
      consolidateOwnedKeyItems(gameRef)
      gameRef.stack:push(Menu.new(gameRef, {
        { label = "FIELD TOOLS", onSelect = openFieldTools },
        { label = "FISHING GEAR", onSelect = openFishingGear },
        { label = "EQUIPMENT", onSelect = openEquipment },
        { label = "LAPTOP", onSelect = function() useStoredKeyItem(LAPTOP_ID) end },
        { label = "REGISTER", onSelect = openRegisterMenu },
        { label = "CANCEL" },
      }, { tx = 2, ty = 2, tw = 16 }))
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
      if mod.save:get("toolkit_received_v1") then
        consolidateOwnedKeyItems(g)
        if not mod.save:get("registered_key_item_v1") then
          mod.save:set("registered_key_item_v1", TOOLKIT_ID)
        end
      end
    end)

    -- Hide consolidated equipment from the normal Bag and Player PC while
    -- leaving its ownership mirrored in save.inventory for vanilla scripts.
    do
      local okBagMenu, BagMenu = pcall(require, "src.ui.BagMenu")
      if okBagMenu and BagMenu and not BagMenu._vanillaPlusToolkitConsolidationWrapped then
        BagMenu._vanillaPlusToolkitConsolidationWrapped = true
        local previousBagNew = BagMenu.new
        function BagMenu.new(g, opts)
          return withConsolidatedInventoryHidden(g, function()
            return previousBagNew(g, opts)
          end)
        end
      end
      local okPlayerPC, PlayerPC = pcall(require, "src.ui.PlayerPC")
      if okPlayerPC and PlayerPC and not PlayerPC._vanillaPlusToolkitConsolidationWrapped then
        PlayerPC._vanillaPlusToolkitConsolidationWrapped = true
        local previousPCNew = PlayerPC.new
        function PlayerPC.new(g, opts)
          if not mod.save:get("toolkit_received_v1") then return previousPCNew(g, opts) end
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
                  if not (id and toolkitOwns(id)) then filtered[#filtered + 1] = item end
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
            for _, id in ipairs(CONSOLIDATABLE_KEY_ITEMS) do
              if toolkitOwns(id) and save.inventory[id]
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
        return originalUse(data, save, itemId, target, battle, moveIndex, ow)
      end
    end

    mod.events:on("map.entered", function()
      if mod.save:get("toolkit_received_v1") then consolidateOwnedKeyItems(gameRef) end
    end)

    -- Registered key item: SELECT in the idle overworld invokes one stored
    -- key item directly. The Toolkit is registered automatically at Mom's
    -- handoff; REGISTER inside the Toolkit can switch it to another owned item.
    if not OverworldState._vanillaPlusRegisteredItemWrapped then
      OverworldState._vanillaPlusRegisteredItemWrapped = true
      local previousRegisteredUpdate = OverworldState.update
      local selectFrames, selectArmed, selectLongUsed = 0, false, false
      function OverworldState:update(...)
        local input = gameRef and gameRef.input
        local canUse = input and gameRef.stack and gameRef.stack:top() == self
          and self.player and not self.player.moving
          and not self.transitioning
          and (not self.runner or not self.runner:isRunning())
          and #((self.scriptMoves) or {}) == 0
        if not canUse then
          selectFrames, selectArmed, selectLongUsed = 0, false, false
          return previousRegisteredUpdate(self, ...)
        end
        if input:wasPressed("select") then
          selectArmed, selectLongUsed = true, false
          selectFrames = input:isDown("select") and 1 or 0
          -- Touch taps can press+release between fixed steps. Treat those as
          -- an immediate normal registered-item tap.
          if not input:isDown("select") then
            local id = mod.save:get("registered_key_item_v1")
            if id and mod.save:get("toolkit_received_v1") then useStoredKeyItem(id); return end
          end
        elseif selectArmed and input:isDown("select") then
          selectFrames = selectFrames + 1
          if selectFrames >= 24 and not selectLongUsed
            and mod.save:get("toolkit_received_v1") then
            selectLongUsed = true
            openRegisterMenu()
            return
          end
        elseif selectArmed and not input:isDown("select") then
          if not selectLongUsed then
            local id = mod.save:get("registered_key_item_v1")
            if id and mod.save:get("toolkit_received_v1") then
              selectArmed = false
              useStoredKeyItem(id)
              return
            end
          end
          selectFrames, selectArmed, selectLongUsed = 0, false, false
        end
        return previousRegisteredUpdate(self, ...)
      end
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
      show(vpFormatDialogue("MOM: " .. playerName() .. "! There you are. Nurse Joy said you might stop by. You've traveled all over KANTO now, so I put together something useful for your adventures."), function()
        local added = Bag.add(g.save, TOOLKIT_ID, 1, g.data)
        if not added then
          return show(vpFormatDialogue("MOM: Your BAG is full! Make some room and come talk to me again."))
        end
        mod.save:set("toolkit_received_v1", true)
        consolidateOwnedKeyItems(g)
        mod.save:set("registered_key_item_v1", TOOLKIT_ID)
        show(vpFormatDialogue("MOM: I organized your adventure gear while you were away. I even checked your PC and put your key gear into the TOOLKIT. I bought you a few extra things too... and this fancy new thing called a LAPTOP!"), function()
          show(vpFormatDialogue(playerName() .. " received the ADVENTURER'S TOOLKIT! Press SELECT in the overworld to use it. Hold SELECT to reopen REGISTER."))
        end)
      end)
    end

    if not OverworldState._vanillaPlusMomToolkitTalkWrapped then
      OverworldState._vanillaPlusMomToolkitTalkWrapped = true
      local previousTalkTo = OverworldState.talkTo
      function OverworldState:talkTo(npc)
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

    -- Mimey: post-Champion household life. He uses a normal classic sprite
    -- and WALK behavior so the house visibly changes instead of gaining a
    -- decorative statue.
    local function maybeSpawnMimey()
      local g, ow = gameRef, gameRef and gameRef.overworld
      if not (g and ow and ow.map and ow.map.id == "REDS_HOUSE_1F") then return end
      removeTagged(ow, "vpMimey")
      if not mod.options:get("postgame_mimey")
        or not (g.save.flags and g.save.flags.EVENT_BEAT_CHAMPION_RIVAL) then return end
      local sprite = g.data.sprites.SPRITE_MONSTER and "SPRITE_MONSTER"
      if not sprite then return end
      local x, y = nearbyFreeCell(ow, 5, 4)
      if not x then x, y = nearbyFreeCell(ow, ow.player.cellX, ow.player.cellY) end
      if not x then return end
      local mime = addRuntimeNPC(ow, "vpMimey", sprite, x, y, "WALK")
      if mime then
        mime.species = "MR_MIME"
        mime.enhancedDexId = "MR_MIME"
      end
    end

    if not OverworldState._vanillaPlusMimeTalkWrapped then
      OverworldState._vanillaPlusMimeTalkWrapped = true
      local previousTalkTo = OverworldState.talkTo
      local mimeLines = {
        "MR.MIME is carefully\nsweeping the floor.",
        "MR.MIME wipes down\nthe table with great\nconcentration.",
        "MR.MIME pauses its\ncleaning.\fMime! Mime!",
        "MR.MIME straightens\nup the room, then\nlooks very pleased.",
      }
      function OverworldState:talkTo(npc)
        if npc and npc.vpMimey then
          npc:facePlayer(self.player)
          show(mimeLines[love.math.random(#mimeLines)])
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

        if surfboardActive and p.surfing then
          self._vpSurfboardImage = self._vpSurfboardImage or love.graphics.newImage(mod.assets:path("assets/vp_surfboard.png"))
          self._vpSurfboardImage:setFilter("nearest", "nearest")
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.draw(self._vpSurfboardImage, px - 12, py + 4)
        end

        if balloonActive and self.flyAnim then
          self._vpBalloonImage = self._vpBalloonImage or love.graphics.newImage(mod.assets:path("assets/vp_balloon.png"))
          self._vpBalloonImage:setFilter("nearest", "nearest")
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.draw(self._vpBalloonImage, px - 14, py - 32)
        end

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
    local input = self.game.input

    if self.page == 2
      and mod.options:get("dv_summary")
      and input:wasPressed("select") then
      self.vpHiddenMode = (self.vpHiddenMode == "statExp") and "dvs" or "statExp"
      return
    end

    if input:wasPressed("a") or input:wasPressed("b") then
      if self.page < 3 then
        self.page = self.page + 1
      else
        self.game.stack:pop()
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
    -- evolved forms plus a 1% AERODACTYL slot.
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
  end

  end

end
