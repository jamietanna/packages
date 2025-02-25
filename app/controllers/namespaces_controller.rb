class NamespacesController < ApplicationController
  def index
    @registry = Registry.find_by!(name: params[:registry_id])
    @pagy, @namespaces = pagy_array(@registry.packages.where.not(namespace: nil).group(:namespace).order('COUNT(id) desc').count.to_a)
  end

  def show
    @registry = Registry.find_by!(name: params[:registry_id])
    @namespace = params[:id]

    scope = @registry.packages.namespace(@namespace)

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

  def maintainers
    @registry = Registry.find_by!(name: params[:registry_id])
    @namespace = params[:id]
    @scope = @registry.namespace_maintainers(@namespace)
    @pagy, @maintainers = pagy_countless(@scope)
  end
end