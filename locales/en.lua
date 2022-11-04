local Translations = {
    error = {
        ["missing_something"] = "Izskatās kad kaut kas pietrūkst...",
        ["not_enough_police"] = "Nav pietiekami daudz policisti pilsētā..",
        ["door_open"] = "Šīs durvis ir jau atvērtas..",
        ["cancelled"] = "Process Atcelts..",
        ["didnt_work"] = "Diemžēl šis nestrādāja..",
        ["emty_box"] = "Kaste bija tukša..",
        ["injail"] = "Tu es AdminJailā uz %{Time} Minūtēm!",
        ["item_missing"] = "Tev pietrūkst kāda lieta..",
        ["escaped"] = "Tu izbēgi no AdminJaila!",
        ["do_some_work"] = "Izdari kādus darbiņus lai laiks atrāk paiet: %{currentjob} ",
    },
    success = {
        ["found_phone"] = "Tu atradi Telefonu..",
        ["time_cut"] = "Tākā aizmuki, laiks pienāca klāt!  Nemūc prom!",
        ["time_cuts"] = "Malacis šādi darot tiksi ātrāk ārā no AdminJaila!",
        ["time_cutss"] = "Zaudēji MiniGame, varbūt dabuji klāt laiku :(",
        ["free_"] = "Tiki ārā no AdminJaila! Lūdzu vairāk nepārkāp noteikumus un izbaudi šo RolePlay!",
        ["timesup"] = "Tavs Laiks ir beidzies!",
    },
    info = {
        ["timeleft"] = "Tev vel palikušas  %{JAILTIME}  Minūtes!",
        ["admin"] = "Tu pārkāpi %{iemsls} !",
        ["lost_job"] = "Tu esi Bezdarbinieks",
        ["jail_time"] = 'Laiks cik viņiem jāatrodas cietumā',
        ["jail_time_no"] = 'Cietuma laikam ir jābūt lielākam par 0',
        ["sent_jail_for"] = 'Jūs nosūtījāt personu adminjailā uz %{time} minūtēm',
        ["jail_time_input"] = 'Adminjail laiks',

    },
    commands = {

        ["jail_player"] = 'Ievietot cietuma (tikai policija)',
        ["unjail_player"] = 'Iznemt no cietuma (tikai policija)',
    },
}
Lang = Locale:new({
phrases = Translations,
warnOnMissing = true})
