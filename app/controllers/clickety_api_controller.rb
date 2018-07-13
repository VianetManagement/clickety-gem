class ClicketyApiController < ApplicationController
  def goal
    response = {}
    if params[:goal].present? && ENV['CLICKETY_GOALS'].present?
      goals = {}
      ENV['CLICKETY_GOALS'].split(",").each {|g| pair = g.split(":"); goals[pair[0]] = pair[1]; }
      if goals.keys.include?(params[:goal])
        response = track(params[:goal])
      else
        response["errors"] = "Error - goal is invalid."
      end
    end

    respond_to do |format|
      format.all { render json: response.to_json and return }
    end
  end

  private
  def track(event)
    response = {}
    goals = {}
    domain = ENV['CLICKETY_COOKIE_DOMAIN'].present? ? ENV['CLICKETY_COOKIE_DOMAIN'] : request.host_with_port
    ENV['CLICKETY_GOALS'].split(",").each {|g| pair = g.split(":"); goals[pair[0]] = pair[1]; }
    goal = goals[event]
    user_id = cookies.encrypted[:clickety_user_id]
    completed_goals = cookies.encrypted[:goals]
    if completed_goals.blank? || completed_goals.present? && !completed_goals.include?(goal)
      track_params = {completion: true, completion_goal_id: goal}
      track_params[:user_id] = user_id unless user_id.blank?
      result = Api.track_user(track_params)
      if result[:response].present?
        response = JSON.parse(result[:response])
        if response["success"].present? && response["success"]["user_id"].present? && user_id != response["success"]["user_id"]
          cookies.encrypted[:clickety_user_id] = {value: response["success"]["user_id"], domain: domain}
          if completed_goals.present?
            completed_goals = completed_goals.split(",").append(goal).join(',')
          else
            completed_goals = goal
          end
          cookies.encrypted[:goals] = completed_goals
        end
      else
        Rails.logger.info "FYI - result response was not present for #{event}:"
        Rails.logger.info result.inspect
      end
    else
      Rails.logger.info "Completed goals already includes #{event}"
    end

    response
  end
end
