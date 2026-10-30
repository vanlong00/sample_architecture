# Copy deck (en, vi, pt-BR draft)

Status column: **keep** = already in `app_en.arb`/`app_vi.arb` with this text; **changed** = key exists, text changes; **new** = add the key; **drop** = remove. pt-BR is a draft for a native reviewer and is not in the app yet (add `app_pt.arb` when Portuguese ships). Placeholders use ARB/ICU syntax.

## Tone guide
- Plain, short, active, second person ("you" / "bạn" / "você"). Say what happened and what to do next.
- Never technical text: no status codes, exception names or file paths.
- Name the game "PBSU" in buttons and status, "Proton Bus Simulator Urbano" once in the dialog that explains it.
- Units always: "60 MB", "42%". Numbers formatted by locale (`NumberFormat`).
- Consistent verbs: en download / import; vi **tải xuống** / **nhập** (as the arb already does); pt-BR **baixar** / **importar**.
- Vietnamese: "Nhấn" for tap; "Vui lòng" only in error retries; no exclamation marks in any language.
- Pro copy is honest: it removes ads and nothing else; no urgency, no "best value".
- Sentence case everywhere; uppercase only on plates (type names, wordmark), created with `toUpperCase()` on the localized type label.

## Navigation and types

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| appTitle | keep | Busmod | Busmod | Busmod |
| navHome | keep | Home | Trang chủ | Início |
| navSearch | keep | Search | Tìm kiếm | Buscar |
| navLibrary | new (4-tab) | Library | Thư viện | Biblioteca |
| navDownloaded | keep | Downloaded | Đã tải | Baixados |
| navFavorites | keep | Favorites | Yêu thích | Favoritos |
| navSettings | keep | Settings | Cài đặt | Ajustes |
| typeBus | keep | Bus | Xe buýt | Ônibus |
| typeTruck | keep | Truck | Xe tải | Caminhão |
| typeCar | keep | Car | Ô tô | Carro |
| typeMap | keep | Map | Bản đồ | Mapa |

## Home, sort, filters

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| sortPopular | keep | Popular | Phổ biến | Populares |
| sortNewest | keep | Newest | Mới nhất | Mais recentes |
| filterTitle | keep | Filters | Bộ lọc | Filtros |
| filterButtonActive | new | Filters · {count} | Bộ lọc · {count} | Filtros · {count} |
| filterActiveSemantics | changed | Filters, {count} active | Bộ lọc, {count} đang bật | Filtros, {count} ativos |
| filterSheetScope | new | Filtering {type} mods | Lọc mod {type} | Filtrando mods de {type} |
| filterBodyType | keep | Body type | Kiểu thân xe | Carroceria |
| filterManufacturer | keep | Manufacturer | Hãng sản xuất | Fabricante |
| filterCountry | keep | Country | Quốc gia | País |
| filterAll | keep | All | Tất cả | Todos |
| filterShowAll | new | Show all ({count}) | Xem tất cả ({count}) | Ver todos ({count}) |
| filterShowFewer | new | Show fewer | Thu gọn | Ver menos |
| filterOptionSemantics | new | {name}, {count} mods | {name}, {count} mod | {name}, {count} mods |
| filterApply | keep | Apply | Áp dụng | Aplicar |
| filterReset | keep | Reset | Đặt lại | Limpar |
| filterClearAll | new | Clear filters | Xóa bộ lọc | Limpar filtros |
| filterRemoveSemantics | new | Remove filter {name} | Bỏ bộ lọc {name} | Remover filtro {name} |
| filterLoadError | new | Couldn't load filters. | Không tải được bộ lọc. | Não foi possível carregar os filtros. |
| listEmpty | drop | (replaced by the two below) | | |
| homeEmptyTitle | new | No mods here yet | Chưa có mod nào | Ainda não há mods aqui |
| homeEmptyBody | new | Check back soon. | Hãy quay lại sau nhé. | Volte em breve. |
| homeFilteredEmptyTitle | new | No mods match these filters | Không có mod nào khớp bộ lọc | Nenhum mod corresponde a esses filtros |
| homeFilteredEmptyBody | new | Try another body type or manufacturer. | Thử kiểu thân xe hoặc hãng khác. | Tente outra carroceria ou fabricante. |
| loadMoreFailed | new | Couldn't load more | Không tải thêm được | Não foi possível carregar mais |
| modDownloadsCount | keep | {count} downloads | {count} lượt tải | {count} downloads |
| mapRoutesCount | new | {count, plural, =1{1 route} other{{count} routes}} | {count} tuyến | {count, plural, =1{1 linha} other{{count} linhas}} |
| mapStopsCount | new | {count, plural, =1{1 stop} other{{count} stops}} | {count} điểm dừng | {count, plural, =1{1 parada} other{{count} paradas}} |
| statusDownloaded | new | Downloaded | Đã tải | Baixado |

## Search

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| searchHint | keep | Search mods | Tìm kiếm mod | Buscar mods |
| searchClear | changed | Clear search | Xóa nội dung tìm kiếm | Limpar busca |
| searchAllTypes | keep | All types | Tất cả loại | Todos os tipos |
| searchPromptTitle | new | Find a bus, truck, car or map | Tìm xe buýt, xe tải, ô tô hoặc bản đồ | Encontre ônibus, caminhões, carros ou mapas |
| searchPromptBody | new | Try a model, a manufacturer or a city, like Citaro or São Paulo. | Thử tên mẫu xe, hãng hoặc thành phố, ví dụ Citaro hay São Paulo. | Tente um modelo, fabricante ou cidade, como Citaro ou São Paulo. |
| searchEmpty | changed | No mods found for “{query}” | Không tìm thấy mod nào cho “{query}” | Nenhum mod encontrado para “{query}” |
| searchEmptyHint | new | Check the spelling or try fewer words. | Kiểm tra chính tả hoặc thử ít từ hơn. | Confira a ortografia ou use menos palavras. |
| searchAllTypesAction | new | Search all types | Tìm trong tất cả loại | Buscar em todos os tipos |
| searchResultsUpdated | new | Results updated | Đã cập nhật kết quả | Resultados atualizados |
| searchOfflineBody | new | Search needs a connection. Your downloaded mods are in Library. | Tìm kiếm cần kết nối mạng. Mod đã tải nằm trong Thư viện. | A busca precisa de conexão. Seus mods baixados estão na Biblioteca. |

## Detail

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| detailSpecs | keep | Specifications | Thông số kỹ thuật | Especificações |
| specGroupCompatibility | new | Compatibility | Tương thích | Compatibilidade |
| specGroupTechnical | new | Technical | Kỹ thuật | Técnico |
| specGroupFeature | new | Features | Tính năng | Recursos |
| detailDescription | keep | Description | Mô tả | Descrição |
| detailReadMore | new | Read more | Xem thêm | Ler mais |
| detailShowLess | new | Show less | Thu gọn | Mostrar menos |
| detailMoreFrom | keep | More from {name} | Thêm từ {name} | Mais de {name} |
| detailMoreLike | keep | More like this | Mod tương tự | Mais como este |
| factSize | new | Size | Dung lượng | Tamanho |
| factFormat | new | Format | Định dạng | Formato |
| factDownloads | new | Downloads | Lượt tải | Downloads |
| factRegion | new | Region | Khu vực | Região |
| factRoutes | new | Routes | Tuyến | Linhas |
| factBusStops | new | Bus stops | Điểm dừng | Paradas |
| galleryCounter | new | {current} / {total} | {current} / {total} | {current} / {total} |
| gallerySemantics | new | Screenshot {current} of {total} | Ảnh {current} trên {total} | Imagem {current} de {total} |
| galleryNext | new | Next screenshot | Ảnh tiếp theo | Próxima imagem |
| galleryPrevious | new | Previous screenshot | Ảnh trước | Imagem anterior |
| close | new | Close | Đóng | Fechar |
| errorModNotAvailable | keep | This mod is no longer available | Mod này không còn khả dụng | Este mod não está mais disponível |
| detailUnavailableBody | new | It was removed from the catalog. If you downloaded it, it's still in Library. | Mod đã bị gỡ khỏi danh mục. Nếu bạn đã tải, mod vẫn còn trong Thư viện. | Ele foi removido do catálogo. Se você baixou, ele continua na Biblioteca. |
| favoriteAdd | keep | Add to favorites | Thêm vào yêu thích | Adicionar aos favoritos |
| favoriteRemove | keep | Remove from favorites | Xóa khỏi yêu thích | Remover dos favoritos |
| favoriteAdded | new | Added to favorites | Đã thêm vào yêu thích | Adicionado aos favoritos |
| favoriteRemoved | new | Removed from favorites | Đã xóa khỏi yêu thích | Removido dos favoritos |

## Action bar, download, import

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| ctaChecking | new | Checking download status | Đang kiểm tra trạng thái tải | Verificando o download |
| ctaDownload | keep | Download | Tải xuống | Baixar |
| ctaDownloadWithSize | new | Download · {size} | Tải xuống · {size} | Baixar · {size} |
| ctaDownloading | keep | Downloading {percent}% | Đang tải {percent}% | Baixando {percent}% |
| ctaDownloadingUnknown | keep | Downloading… | Đang tải… | Baixando… |
| ctaProgressBytes | new | {received} of {total} | {received} / {total} | {received} de {total} |
| ctaCancel | keep | Cancel | Hủy | Cancelar |
| ctaCancelSemantics | new | Cancel download | Hủy tải xuống | Cancelar download |
| ctaDownloadedStatus | new | Downloaded · {size} | Đã tải · {size} | Baixado · {size} |
| ctaImport | keep | Import to PBSU | Nhập vào PBSU | Importar no PBSU |
| ctaImportSemantics | new | Import {title} to PBSU | Nhập {title} vào PBSU | Importar {title} no PBSU |
| ctaImporting | new | Sending to PBSU | Đang gửi tới PBSU | Enviando ao PBSU |
| ctaRedownload | keep | Download again | Tải lại | Baixar de novo |
| ctaFileMissing | changed | File not found on this device | Không tìm thấy tệp trên thiết bị | Arquivo não encontrado no aparelho |
| fileNotFoundShort | new | File not found | Không tìm thấy tệp | Arquivo não encontrado |
| downloadFailedNetwork | new | Download stopped. Check your connection. | Tải xuống bị dừng. Hãy kiểm tra kết nối mạng. | Download interrompido. Verifique sua conexão. |
| downloadStorageFull | new | Not enough space. Free up {size} and try again. | Không đủ dung lượng. Hãy giải phóng {size} rồi thử lại. | Espaço insuficiente. Libere {size} e tente de novo. |
| downloadCheckFailed | new | Couldn't check this download. | Không kiểm tra được bản tải này. | Não foi possível verificar este download. |
| retry | keep | Retry | Thử lại | Tentar de novo |
| importSent | keep | Mod sent to PBSU | Đã gửi mod tới PBSU | Mod enviado ao PBSU |
| importChooserHint | changed | Pick PBSU in the list to import this mod | Chọn PBSU trong danh sách để nhập mod này | Escolha o PBSU na lista para importar este mod |
| importFailed | changed | PBSU couldn't open this mod. Try again. | PBSU không mở được mod này. Vui lòng thử lại. | O PBSU não conseguiu abrir este mod. Tente de novo. |
| pbsuMissingTitle | changed | PBSU is not installed | Chưa cài PBSU | O PBSU não está instalado |
| pbsuMissingBody | changed | Mods are sent to Proton Bus Simulator Urbano, which installs them. Install the game from Google Play, then tap Import again. | Mod được gửi tới Proton Bus Simulator Urbano để game tự cài đặt. Hãy cài game từ Google Play rồi nhấn Nhập lại. | Os mods são enviados ao Proton Bus Simulator Urbano, que os instala. Instale o jogo pelo Google Play e toque em Importar de novo. |
| pbsuOpenStore | keep | Open Google Play | Mở Google Play | Abrir Google Play |
| notNow | new | Not now | Để sau | Agora não |

## Library

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| downloadedSummary | new (replaces downloadedTotal) | {count, plural, =1{1 mod} other{{count} mods}} · {size} on this device | {count} mod · {size} trên thiết bị | {count, plural, =1{1 mod} other{{count} mods}} · {size} no aparelho |
| downloadedTotal | drop | | | |
| downloadedEmpty | changed | No downloads yet | Chưa tải mod nào | Nenhum download ainda |
| downloadedEmptyBody | new | Mods you download show up here and work offline. | Mod bạn tải sẽ hiện ở đây và dùng được khi ngoại tuyến. | Os mods que você baixar aparecem aqui e funcionam offline. |
| downloadedLoadError | new | Couldn't read your downloads. | Không đọc được danh sách đã tải. | Não foi possível ler seus downloads. |
| actionBrowseMods | new | Browse mods | Khám phá mod | Explorar mods |
| deleteConfirmTitle | changed | Delete this mod? | Xóa mod này? | Excluir este mod? |
| deleteConfirmBody | changed (adds {size}) | “{title}” will be removed from this device and free {size}. You can download it again later. | “{title}” sẽ bị xóa khỏi thiết bị, giải phóng {size}. Bạn có thể tải lại sau. | “{title}” será removido do aparelho e liberará {size}. Você pode baixar de novo depois. |
| delete | keep | Delete | Xóa | Excluir |
| cancel | keep | Cancel | Hủy | Cancelar |
| deleteModSemantics | keep | Delete {title} | Xóa {title} | Excluir {title} |
| deleteDone | new | Mod deleted | Đã xóa mod | Mod excluído |
| deleteFailed | new | Couldn't delete the file. Try again. | Không xóa được tệp. Vui lòng thử lại. | Não foi possível excluir o arquivo. Tente de novo. |
| favoritesSummary | new | {count, plural, =1{1 saved mod} other{{count} saved mods}} | {count} mod đã lưu | {count, plural, =1{1 mod salvo} other{{count} mods salvos}} |
| favoritesEmpty | changed | No favorites yet | Chưa có mod yêu thích | Nenhum favorito ainda |
| favoritesEmptyBody | new | Tap the heart on a mod to save it here. | Nhấn vào trái tim trên mod để lưu vào đây. | Toque no coração de um mod para salvá-lo aqui. |
| favoriteRemoveSemantics | keep | Remove {title} from favorites | Xóa {title} khỏi yêu thích | Remover {title} dos favoritos |
| undo | new | Undo | Hoàn tác | Desfazer |

## Settings

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| settingsTheme | changed | Appearance | Giao diện | Aparência |
| themeSystem | keep | System | Theo hệ thống | Sistema |
| themeLight | keep | Light | Sáng | Claro |
| themeDark | keep | Dark | Tối | Escuro |
| settingsLanguage | keep | Language | Ngôn ngữ | Idioma |
| settingsPurchases | new | Purchases | Giao dịch | Compras |
| settingsAbout | new | About | Thông tin | Sobre |
| settingsPro | drop (replaced by proCard*) | | | |
| proCardTitle | new | Remove ads with Pro | Gỡ quảng cáo với Pro | Remova os anúncios com o Pro |
| proCardBody | new | One subscription. No ads anywhere in the app. | Một gói đăng ký. Không còn quảng cáo trong toàn bộ ứng dụng. | Uma assinatura. Nenhum anúncio no app. |
| proCardAction | new | See Pro | Xem Pro | Ver o Pro |
| proActive | changed | You're Pro | Bạn đang dùng Pro | Você é Pro |
| proActiveBody | new | Thanks for supporting the app. Ads are off. | Cảm ơn bạn đã ủng hộ. Quảng cáo đã tắt. | Obrigado pelo apoio. Os anúncios estão desativados. |
| proManage | new | Manage subscription | Quản lý gói đăng ký | Gerenciar assinatura |
| settingsRestore | keep | Restore purchases | Khôi phục giao dịch | Restaurar compras |
| settingsPrivacy | keep | Privacy policy | Chính sách bảo mật | Política de privacidade |
| settingsTerms | keep | Terms of use | Điều khoản sử dụng | Termos de uso |
| settingsPrivacyChoices | new (fe-consent-privacy) | Privacy choices | Lựa chọn quyền riêng tư | Opções de privacidade |
| settingsVersion | keep | Version {v} | Phiên bản {v} | Versão {v} |
| linkOpensInBrowser | new (semantics hint) | Opens in browser | Mở trong trình duyệt | Abre no navegador |
| linkOpenFailed | new | Couldn't open the page. | Không mở được trang. | Não foi possível abrir a página. |

## Pro paywall

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| proTitle | keep | Busmod Pro | Busmod Pro | Busmod Pro |
| proHeadline | new | Busmod without ads | Busmod không quảng cáo | Busmod sem anúncios |
| proBenefitNoAds | drop (split into 3) | | | |
| proBenefitLists | new | No ads in lists | Không quảng cáo trong danh sách | Sem anúncios nas listas |
| proBenefitDownloads | new | No ads before downloads | Không quảng cáo trước khi tải | Sem anúncios antes dos downloads |
| proBenefitAppOpen | new | No ads when you open the app | Không quảng cáo khi mở ứng dụng | Sem anúncios ao abrir o app |
| proNoChange | new | Every mod stays free to download and import, with or without Pro. | Mọi mod vẫn miễn phí tải và nhập, dù có Pro hay không. | Todos os mods continuam grátis para baixar e importar, com ou sem o Pro. |
| proPricePerMonth | new | {price} / month | {price} / tháng | {price} / mês |
| proRenewal | new | Renews every month until you cancel in Google Play. | Tự gia hạn hằng tháng cho tới khi bạn hủy trong Google Play. | Renova todo mês até você cancelar no Google Play. |
| proSubscribe | keep | Subscribe | Đăng ký | Assinar |
| proPurchased | changed | You're Pro. Ads are gone. | Bạn đã là Pro. Quảng cáo đã được gỡ. | Agora você é Pro. Os anúncios sumiram. |
| proRestored | keep | Purchases restored | Đã khôi phục giao dịch | Compras restauradas |
| proNothingToRestore | keep | Nothing to restore | Không có gì để khôi phục | Nada para restaurar |
| proPending | changed | Payment pending. Pro turns on when Google Play confirms it. | Thanh toán đang chờ xử lý. Pro sẽ bật khi Google Play xác nhận. | Pagamento pendente. O Pro será ativado quando o Google Play confirmar. |
| proPurchaseFailed | changed | Purchase didn't go through. Try again. | Giao dịch chưa thành công. Vui lòng thử lại. | A compra não foi concluída. Tente de novo. |
| proStoreUnavailable | changed | Google Play isn't available right now. | Google Play hiện không khả dụng. | O Google Play não está disponível agora. |
| proOffline | new | You're offline. Connect to subscribe. | Bạn đang ngoại tuyến. Hãy kết nối mạng để đăng ký. | Você está offline. Conecte-se para assinar. |
| proRestoreFailed | keep | Couldn't restore purchases. Try again later. | Không thể khôi phục giao dịch. Vui lòng thử lại sau. | Não foi possível restaurar as compras. Tente mais tarde. |

## Ads

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| adLabel | keep | Ad | Quảng cáo | Anúncio |
| adRemove | new | Remove ads | Gỡ quảng cáo | Remover anúncios |
| adContainerSemantics | new | Advertisement | Quảng cáo | Publicidade |

## Errors, offline, splash

| Key | Status | en | vi | pt-BR |
|---|---|---|---|---|
| errorServer | changed | Something went wrong on our side. Try again in a moment. | Máy chủ đang gặp sự cố. Vui lòng thử lại sau ít phút. | Algo deu errado do nosso lado. Tente de novo em instantes. |
| errorNetwork | changed | You're offline. Check your connection. | Bạn đang ngoại tuyến. Hãy kiểm tra kết nối mạng. | Você está offline. Verifique sua conexão. |
| errorCache | changed | Couldn't read data on this device. | Không đọc được dữ liệu trên thiết bị. | Não foi possível ler os dados do aparelho. |
| errorUnknown | changed | Something went wrong. Try again. | Đã có lỗi xảy ra. Vui lòng thử lại. | Algo deu errado. Tente de novo. |
| errorUnauthorized | drop (fe-cleanup-docs) | | | |
| errorStorageFull | keep | Not enough storage space on your device. | Bộ nhớ thiết bị không đủ dung lượng. | Não há espaço suficiente no aparelho. |
| offlineTitle | new | You're offline | Bạn đang ngoại tuyến | Você está offline |
| offlineBody | new | Check your connection. Your downloaded mods still work in Library. | Hãy kiểm tra kết nối mạng. Mod đã tải vẫn dùng được trong Thư viện. | Verifique sua conexão. Seus mods baixados continuam funcionando na Biblioteca. |
| offlineBanner | new | Offline. Showing saved results. | Ngoại tuyến. Đang hiện kết quả đã lưu. | Offline. Mostrando resultados salvos. |
| actionOpenLibrary | new | Open Library | Mở Thư viện | Abrir Biblioteca |
| loading | new | Loading | Đang tải | Carregando |
| splashTagline | new | Mods for Proton Bus Simulator Urbano | Mod cho Proton Bus Simulator Urbano | Mods para o Proton Bus Simulator Urbano |
| splashSlow | new | Still loading… | Vẫn đang tải… | Ainda carregando… |

With the 5-tab option, "Library" in offlineBody, searchOfflineBody, detailUnavailableBody and actionOpenLibrary becomes "Downloaded" / "Đã tải" / "Baixados".

## Deferred (Phase 2)

| Key | en | vi | pt-BR |
|---|---|---|---|
| forceUpdateTitle | Update required | Cần cập nhật | Atualização necessária |
| forceUpdateBody | This version no longer works with the mod catalog. Update to keep browsing and downloading mods. Your downloaded mods are safe. | Phiên bản này không còn dùng được với danh mục mod. Hãy cập nhật để tiếp tục xem và tải mod. Mod đã tải vẫn an toàn. | Esta versão não funciona mais com o catálogo de mods. Atualize para continuar navegando e baixando mods. Seus mods baixados estão seguros. |
| forceUpdateAction | Update | Cập nhật | Atualizar |
| softUpdateBanner | A new version is available | Đã có phiên bản mới | Nova versão disponível |
