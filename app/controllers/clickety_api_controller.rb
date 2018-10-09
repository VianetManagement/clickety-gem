class ClicketyApiController < ApplicationController
  def goal
    response = {}
    if params[:goal].present? && ENV['CLICKETY_GOALS'].present?
      goals = {}
      ENV['CLICKETY_GOALS'].split(",").each {|g| pair = g.split(":"); goals[pair[0]] = pair[1]; }
      if goals.keys.include?(params[:goal])
        if params[:user_id].present?
          response = track(params[:goal], params[:user_id])
        else
          response = track(params[:goal])
        end
      else
        response["errors"] = "Error - goal is invalid."
      end
    elsif params[:completion_goal_id].present?
      json_data = { completion_goal_id: GOALS.fetch(goal, goal), completion: true, verbose: true }
      if params[:campaign_id].present?
        json_data[:user_data] = { campaign_id: params[:campaign_id], replace: true }
      end
      if params[:user_id].present?
        json_data[:user_id] = params[:user_id]
      end
      response = ClicketyApi.track_user(json_data)
    end

    respond_to do |format|
      format.all { render json: response.to_json and return }
    end
  end
  helper_method :submmit_clickety_goal

  private
  def track(event, user_id = nil)
    response = {}
    goals = {}
    domain = ENV['CLICKETY_COOKIE_DOMAIN'].present? ? ENV['CLICKETY_COOKIE_DOMAIN'] : request.host_with_port
    ENV['CLICKETY_GOALS'].split(",").each {|g| pair = g.split(":"); goals[pair[0]] = pair[1]; }
    goal = goals[event]
    user_id = cookies.encrypted[:clickety_user_id] unless user_id.present?
    completed_goals = cookies.encrypted[:goals]
    if completed_goals.blank? || completed_goals.present? && !completed_goals.include?(goal)
      track_params = {completion: true, completion_goal_id: goal}
      track_params[:user_id] = user_id unless user_id.blank?
      response = ClicketyApi.track_user(track_params)
    else
      Rails.logger.info "Completed goals already includes #{event}"
    end

    response
  end
end
