class MaintainersController < ApplicationController
  def index
    @registry = Registry.find_by!(name: params[:registry_id])
    @pagy, @maintainers = pagy_countless(@registry.maintainers.order('packages_count DESC'))
  end

  def show
    @registry = Registry.find_by!(name: params[:registry_id])
    @maintainer = @registry.maintainers.find_by(login: params[:id]) || @registry.maintainers.find_by!(uuid: params[:id])

    scope = @maintainer.packages.includes(:registry)

    if params[:sort].present? || params[:order].present?
      sort = params[:sort].presence || 'updated_at'
      if params[:order] == 'asc'
        scope = scope.order(Arel.sql(sort).asc.nulls_last)
      else
        scope = scope.order(Arel.sql(sort).desc.nulls_last)
      end
    else
      scope = scope.order('updated_at desc')
    end

    @pagy, @packages = pagy_countless(scope)
  end

  def namespaces
    @registry = Registry.find_by!(name: params[:registry_id])
    @maintainer = @registry.maintainers.find_by(login: params[:id]) || @registry.maintainers.find_by!(uuid: params[:id])
    @pagy, @namespaces = pagy_array(@maintainer.namespaces)
  end
end