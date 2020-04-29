class OfferAbility
  include CanCan::Ability

  def initialize(user)
    #Si current_user existe, está logueado.
    if user.present?
      #Admin tiene acceso total.
      if user.has_role? :admin
        can :manage, :all
      else
        #owner existe si user tiene asociado un perfil de propietario
        owner ||= Owner.find_by user_id: user.id

        #User logueado.
        can :read, Offer
        #Solo un user con perfil de owner
        if owner
          can :read, Offer
          can :create, Offer, owner_id: owner.id
          can :update, Offer, owner_id: owner.id
          can :destroy, Offer, owner_id: owner.id
        end
      end
    else
      #Visitantes
      can :show, Offer
    end
  end
end

