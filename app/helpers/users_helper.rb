module UsersHelper
    def turbo_frame_id(param)
      case param.to_s
      when "selected_owner_id"    then "collectors"
      when "selected_partner_id"  then "charges"
      when "selected_collector_id" then "charge_info"
      else
        raise ArgumentError, "Unknown param for turbo_frame_id: #{param.inspect}"
      end
    end
  end
  