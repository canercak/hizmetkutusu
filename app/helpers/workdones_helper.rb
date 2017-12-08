module WorkdonesHelper
include ActionView::Helpers::DateHelper
 
  def  type_options
    [[t("shared.navbar.company_no"), 0], 
    [t("shared.navbar.company_personal"), 1],  
    [t("shared.navbar.company_limited"), 2],
    [t("shared.navbar.company_anonymous"), 3]] 
   end



  def time_periods
    [[t("providers.prices.15min"), 15], 
    [t("providers.prices.30min"), 30],  
    [t("providers.prices.45min"), 45],
    [t("providers.prices.onehr"), 60],
    [t("providers.prices.twohr"), 120],
    [t("providers.prices.threehr"), 180],
    [t("providers.prices.fourhr"), 240],
    [t("providers.prices.fivehr"), 300],
    [t("providers.prices.sixhr"), 360],
    [t("providers.prices.sevenhr"), 420],
    [t("providers.prices.eighthr"), 480]] 
  end
   
end
   
